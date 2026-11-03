# Local AI review before GitHub pull request

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

Reviewed firebase/firestore.rules against ownership and schema requirements. Ten local emulator tests prove the specific listed cases in test-report.md; no open catch-all rule was found. Report metadata URL checks do not prove an object exists, and Storage rules have not yet been emulator-tested. Deploy only after completing the remaining checks. No cloud rules deployment is claimed.

## Required PR evidence still missing

Create a real GitHub PR into main, run the configured AI review tool including firestore.rules, record actual tool findings, screenshots and decisions, fix accepted findings and merge the PR. Do not invent findings or a PR URL. This document must be updated to describe the actual PR result before submission.
