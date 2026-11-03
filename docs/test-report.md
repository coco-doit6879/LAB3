# Verification report

## Latest verification after Cloudinary migration

Live Flow 1 and Flow 2 follow-up: Deadline create/edit/complete/cancel-delete/delete and Study plan/start/navigate/cancel-finish/finish were exercised on the signed-in Firebase-backed Android app. See live-flow-results.md for exact per-run pass/fail scope, logs and images. Validation-label and merged-card selectors caused two preserved failed runs; successful resume steps are recorded separately. These are DSL results, not ten passing `.mob` tests, Console proof, network-recovery proof or full completion of the LAB.

Latest runtime regression: student supplied an Android screenshot of ProviderNotFoundException in _CourseDialog. Saved unchanged as assets/evidence/course-dialog-provider-error.png. A new widget test reproducing the actual nested Navigator/provider tree failed with that same exception before the fix. Dialogs/pickers now use the session Navigator (`useRootNavigator: false`). The test then creates a course successfully and verifies an open dialog disappears when the session subtree is removed. Full suite: **22 tests passed**, analyze clean. This is a real runtime bug/regression test, not the required MobAI deliberate-bug exercise.

Signed-in Android recheck after installing the first fix: Dashboard appeared with the retained session; MobAI open-course-dialog DSL passed all six steps and observed the two editable fields, Hủy and Thêm môn học (course-dialog-open.json). The following typing attempt failed after an unnecessary system Back moved the app to Launcher; its success=false log is preserved in course-create-after-fix.json. No course-create pass is claimed for that run. Extending the regression with handlePopRoute reproduced a second bug: the nested Navigator did not handle system Back. SessionNavigator now forwards through NavigatorPopHandler and maybePop; the same test verifies dialog dismissal on system Back and session removal. Full suite rerun: 22 pass, analyze clean. The saved create script no longer sends Back merely to hide a keyboard that may not be open.

Course labels now resolve from the account's course data in dashboard/list/detail and PDF. Report export receives an immutable label snapshot; its existing test verifies later source-map mutation cannot alter that snapshot. Live PDF verification still pending.

Native recovery result: course-create-run-2.json correctly reports success=false because the keyboard covered Submit; it did not submit. Observing the filled form, a resume script sent Enter/Done, waited for Submit, saved, asserted PRM393 and absence of input fields, and observed the course list. course-create-run-3.json is success=true (8/8 steps), showing “Flutter và Firebase / PRM393” in the signed-in Firestore-backed list. This proves the app's acknowledged course-create/list path after the fix, not full Deadline CRUD or a passing .mob suite. Both failed and successful logs are retained. The full create DSL now includes Enter/Done and readiness wait, but that amended complete script has not been replayed yet (to avoid duplicate courses).

Live backend milestone: student authenticated CLI; Firestore API enabled, default Standard/freeTier database created at asia-southeast1, Rules compiled/released with deploy exit 0. Database get confirmed server metadata. Remote Config initially empty; three parameters published and downloaded back with expected types/values. See backend-deployment.md. Historical pending-deployment statements below are superseded. No signed-in app/cloud CRUD, live PDF or RC behavior proof is implied.

Shared component integration: all screens now use AppButton/AppField/AppTopBar/AppDialog where applicable; StatusPanel delegates loading/empty/error states. After loading indicators and token cleanup, full suite rerun: 21 passed; analyze clean. Tests cover the existing recovery/form/navigation behavior, not every component interaction state or visual Figma parity. See components.md for exact scope and exceptions.

Latest flow-alignment follow-up: full suite rerun, **21 tests pass**, analysis clean. The existing failed-save form case now retries successfully after an injected matching snapshot and verifies arrival at Deadline detail (including edit action). This proves the fake-repository route behavior, not real cloud persistence. Calendar now displays the session status and completed elapsed minutes; that display still needs signed-in Android evidence.

Latest search/filter implementation: **21 Flutter tests pass**, analysis clean. A ViewModel case combines case-insensitive trimmed title search, course and status, verifies that an incoming stream update respects active filters, and confirms reset preserves source records. A widget case renders Deadline list at 360×800 with a simulated 280 px keyboard inset, enters a nonmatching query, resets filters and verifies the original record and cleared search field with no layout exception. These are fake-repository checks; cloud query and signed-in Android demonstration remain pending.

Cloudinary Console inspection found Allowed formats blank under Optimize and Deliver. Official preset documentation states that per-preset file size limits are unsupported; earlier instructions to find a 10 MiB preset field were incorrect. The app's local cap remains 10 MiB. Adapter negative coverage now also supplies a valid PDF header with oversized bytes and verifies no HTTP request occurs. Live format restriction and upload remain pending student Console action.

The targeted Cloudinary test file was rerun after extending those negative cases: 3 tests passed. Production code did not change in this follow-up; the 21-test full-suite result above belongs to the preceding search/filter check.

Subsequent theme/component change: **19 Flutter tests pass**, analysis clean. Three new widget cases check navigation/card layout and callbacks at 360/412/800 dp. They do not replace full-screen Android accessibility checks. See fidelity-check.md for scope and token contrast calculations.

Current local checks: 16 Flutter tests passed; analysis clean. Cloudinary adapter tests cover multipart fields, no privileged credential, progress/result parsing, missing configuration, invalid PDF, rejected upload and invalid delivery URL. They use an HTTP fake and do not prove a live upload.

Cloudinary-configured debug APK build completed successfully (`--no-pub --dart-define-from-file=config/cloudinary.json`); adb install -r returned Success and MainActivity start was accepted. Initial build with pub resolution failed due network/cache permissions; the cached dependency build succeeded. This remains launch/install evidence, not live PDF verification.

Runtime recheck: initial MobAI observation saw the launcher. Reopening with `am start -W` returned Status ok, WARM, MainActivity, TotalTime 3709 ms. The following MobAI observation returned the app's actual Login semantics: “Deadline Mate”, “Bớt lo deadline. Tập trung từng phiên học.”, and button “Tiếp tục với Google”. No successful sign-in is claimed.

18 combined emulator Rules tests passed: 11 Firestore and 7 Storage. The Storage suite uncovered an overwrite authorization bug; create now requires an absent resource and delete requires an absent incoming resource. The suite checks owner isolation, signed-out denial, PDF content type/size bounds, immutable objects, deletion and unknown paths. Test cleanup recursively removes only emulator fixtures because the library root cleanup did not clear nested prefixes.

```powershell
D:\PRM\tools\firebase-cli\node_modules\.bin\firebase.cmd emulators:exec --only 'firestore,storage' --project demo-deadlinemate 'node --test tests/rules/firestore.test.mjs tests/rules/storage.test.mjs'
```

Earlier sections below retain historical verification stages; their smaller counts and pending Storage checks are superseded by this section. No live cloud verification is implied.

Student: SE194007. Product: Deadline Mate. Verification date: 2026-11-03.

## Completed checks

- `dart format lib test`: completed.
- `flutter analyze`: No issues found after Firebase configuration and course dropdown integration.
- `flutter test`: 12 tests passed. Coverage: authentication state/cancellation/logout; bootstrap failure recovery; deadline validation, duplicate submissions, filtering and form preservation after failed save; study duration and transition failure; Remote Config defaults/last-known values; export disabling/failure; notification account isolation and foreground/tap routing requests.
- Firestore Emulator 1.22.0: 10 Rules tests passed, zero failures. Command from repository root:

```powershell
D:\PRM\tools\firebase-cli\node_modules\.bin\firebase.cmd emulators:exec --only firestore --project demo-deadlinemate "node --test tests/rules/firestore.test.mjs"
```

Emulator used localhost:8188 and a demo project, not deadline-mate-feff4 cloud data. Java runtime: Android Studio jbr. Dependencies are recorded in tests/rules/package-lock.json. Permission-denied logs during negative cases are expected; assertFails verifies rejection.

| Rules test | Result |
|---|---|
| Owner deadline create/read/update/delete | Pass |
| Other UID and signed-out read/write/delete denied | Pass |
| Empty/oversized/wrong-type/extra-field deadline denied | Pass |
| createdAt cannot be rewritten | Pass |
| Courses owner and bounded schema | Pass |
| Session planned → running → completed; invalid transitions denied | Pass |
| Session duration bounds and forged initial state denied | Pass |
| Report owner and path metadata | Pass |
| Notification read-only status update; text mutation denied | Pass |
| Unknown collections denied | Pass |

## Not yet proven

Rules tests cover Firestore, not Storage rules. No deployment is claimed. Unit/widget tests use fake repositories, not end-to-end Firebase transactions. Android build/run, Google Sign-In with a test account, background FCM, actual PDF upload, DebugView/Crashlytics receipt and Console Remote Config behavior still need evidence.

MobAI: no scripts or results yet. The required 10 scenarios, healing, deliberate-bug failure and repaired pass have not been run. ARTEMIS substitution remains subject to lecturer instructions. These unit/rules checks do not replace those requirements.

## Android runtime verification

APK debug rebuilt successfully with refreshed OAuth config; adb install returned Success and am start launched MainActivity. Actual emulator screenshot assets/evidence/android-login.png shows the Google login screen. No fatal startup exception was observed in AndroidRuntime output at this check. This proves launch only, not successful Google authentication or any signed-in flow.


## Review fixes and MobAI smoke update

13 Flutter unit/widget tests passed after review fixes; analysis is clean and APK rebuilt successfully. New detail recovery test verifies a failed query is not labeled as a deleted record. The form test also retries twice and verifies both submissions carry the same draft ID. This does not alone prove native transaction timeout behavior.

MobAI CLI 3.5.1 recognized emulator-5554 and started its Android automation bridge. A supplemental login-gate DSL smoke passed 3/3 runs, 7 successful steps per run. Actual result JSON files: assets/evidence/mobai/login-gate-dsl-run-1.json through run-3.json. These runs used the installed, signed-out app and tested startup/login-only access, not successful sign-in or signed-in business flows.

The .mob script was created from the observed UI but the CLI test runner returned `testing not initialized - open a project first`; its real error is preserved in login-gate-run-1.json. The DSL execution is recorded separately and does not count as a passing .mob run. No healing, deliberate-bug exercise or required 10-script suite is claimed.

Official standalone mobai-ci v0.13.2 release assets checked in this session have macOS/Linux binaries and no Windows binary. Do not claim that a Windows CI runner was installed. The desktop app test-project initialization or another supported MobAI setup still needs resolution.
