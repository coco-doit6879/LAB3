# Verification report

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

