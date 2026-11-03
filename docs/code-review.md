# Local AI review before GitHub pull request

## Cloudinary migration and security follow-up

R2 and R3 below refer to the earlier Firebase Storage adapter. That upload path has now been replaced by Cloudinary multipart upload; there is no UploadTask snapshot subscription or separate getDownloadURL call. HTTP failure/progress/response validation have unit coverage. An upload followed by a Firestore failure can still leave an orphan asset: the unsigned client has no privileged delete permission. This limitation is documented in cloudinary-setup.md and must not be represented as guaranteed cleanup.

R6 (security/high): Storage rules allowed replacement through overlapping delete/write authorization. The rule now distinguishes create (resource absent) and delete (incoming resource absent); owner overwrite is rejected. Seven Storage emulator cases pass. Combined with 11 Firestore cases, 18 Rules cases pass. This is a real local finding and fix, not an external PR review.

Tool: Codex assistant in this working session. Baseline reviewed: commit 1b78e8d, branch feature/firebase-integration. This is a local pre-review, not a claim that a GitHub PR review or merge has occurred. Student decisions and external PR evidence remain pending.

| ID | Baseline file and line | Finding and impact | Category/severity | Agent decision and fix | Verification |
|---|---|---|---|---|---|
| R1 | lib/services/firestore_deadline_service.dart:44 | New auto-ID for each create attempt and an unbounded acknowledgement wait make offline recovery ambiguous; a retry could create a second record. | Robustness/high | Accept: allocate ID once per form; reuse on retries; use SDK transaction timeout of 20 seconds and at most 3 attempts. Existing draft ID is updated without resetting createdAt. | Widget test retries failed save and observes the same submitted ID. Actual timeout/transaction behavior still needs Android + emulator/cloud testing. |
| R2 | lib/services/report_service.dart:105 | snapshotEvents listener has no error handler while UploadTask is awaited separately; an upload failure can also escape as an unhandled stream error. | Robustness/medium | Accept: consume stream errors on the progress subscription; awaited task remains the authoritative failure path. | Code inspection and analysis; native upload-failure run pending. |
| R3 | lib/services/report_service.dart:112 | getDownloadURL fails outside the metadata cleanup block, leaving an uploaded file without report metadata. | Robustness/medium | Accept: put URL retrieval and metadata write in one guarded block; attempt object cleanup after any failure following successful upload. | Code inspection; real Storage fault-injection pending. Cleanup is best effort and not guaranteed if permission/network also fails. |
| R4 | lib/screens/deadline_detail_screen.dart:34 | A failed initial query is displayed as a deleted/missing record; recovery action is hidden. | Error recovery/medium | Accept: preserve the real load error and expose retry; only show missing record when no load error exists. | New widget test injects a permission error, checks missing-record text is absent and retry starts loading. |
| R5 | lib/screens/study_screen.dart:78 | End session immediately commits without the confirmation specified in flow 2. | UX/spec fidelity/low | Accept: confirm before committing completion; cancel preserves running session. | Code inspection and analysis; runtime confirmation screenshot/test pending. |

Five findings across robustness and UX/error recovery were acted on. Do not describe this as five findings approved by the student; the student should read/explain and accept, modify or reject each decision. Fixes can be traced with `git diff 1b78e8d..HEAD` after the fix commit.

## Rules review

Deployment follow-up: 11 Firestore + 7 Storage emulator cases passed; Firestore Rules subsequently compiled and released successfully on deadline-mate-feff4. See backend-deployment.md for the local Rules SHA-256 and actual CLI result. The paragraph below records the earlier review stage; it is superseded for test counts and deployment status. Real UID/cloud access checks remain pending.

Reviewed firebase/firestore.rules against ownership and schema requirements. Ten local emulator tests prove the specific listed cases in test-report.md; no open catch-all rule was found. Report metadata URL checks do not prove an object exists, and Storage rules have not yet been emulator-tested. Deploy only after completing the remaining checks. No cloud rules deployment is claimed.

## Required PR evidence still missing

R7 (runtime correctness/high): showDialog used the root Navigator while CoursesViewModel lived above the authenticated inner Navigator. Student's real Android screenshot showed _CourseDialog could not resolve its provider. Reproduced with a nested-navigator widget test before fixing; dialog/picker routes now target the session Navigator and disappear when that session is removed. All 22 Flutter tests pass; analyze clean. This finding came from actual runtime evidence, not an external PR review. It does not replace the MobAI exercise.

R8 (navigation/high): system Back was not forwarded to the authenticated nested Navigator. A live DSL attempt reached Launcher; a handlePopRoute regression independently reproduced the issue with a dialog still on the inner stack. SessionNavigator now uses NavigatorPopHandler/maybePop, preserving dirty-form PopScopes. The updated regression passes, along with all 22 tests. After reinstall, signed-in course creation/list succeeds; screenshot android-course-create-success.png and successful run-3 log are retained. The earlier failed DSL runs remain failures and do not count as passing .mob tests.

Create a real GitHub PR into main, run the configured AI review tool including firestore.rules, record actual tool findings, screenshots and decisions, fix accepted findings and merge the PR. Do not invent findings or a PR URL. This document must be updated to describe the actual PR result before submission.
