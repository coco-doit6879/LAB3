# Firebase setup for Deadline Mate

Project ID: deadline-mate-feff4. Display name: Deadline Mate. Android package: vn.deadlinemate.deadline_mate.

## Verified setup

Android app registered through Firebase Console on 2026-11-03. App ID: 1:106147478931:android:1c1cb783766a35d837fc66. Official google-services.json downloaded and copied to android/app. lib/firebase_options.dart derives the same public identifiers. Google Services 4.5.0 and Crashlytics Gradle 3.0.8 were selected from official Firebase Android setup documentation.

No service-account credential is stored in this repo. Config files contain public app identifiers; Firestore/Storage Rules enforce access.

## Google Sign-In still needs Console setup

At Project settings → General → Android Deadline Mate → Add fingerprint, register this machine's debug SHA-1:

```text
D1:B8:28:A3:8C:49:8D:A7:C1:25:FD:D7:B9:00:E5:FE:5F:50:31:8A
```

This fingerprint is public, not the signing private key. The private debug keystore is outside the repo at the standard Android user location; never upload it. Another machine needs its own SHA-1 registered.

In Authentication → Sign-in method, enable Google and select the project support email. After enabling, download google-services.json again: the current initial download has no OAuth clients. Replace android/app/google-services.json with the refreshed file, preserving the expected package. Verify an OAuth web client is present before testing Google Sign-In.

## Remaining setup

- Firestore database and checked-in Rules have now been deployed: Standard/freeTier, asia-southeast1. See backend-deployment.md. Signed-in CRUD and Console screenshots remain pending.
- Student selected Cloudinary; the active PDF adapter now uses it. Project remains Spark and no billing was enabled. See cloudinary-setup.md for public build configuration and pending live verification. Firebase Storage rules remain as a tested alternative.
- Analytics enabled status, DebugView, Crashlytics onboarding and event receipt need actual verification.
- Remote Config now has dashboard_item_limit=5 (Number), enable_pdf_export=true (Boolean), study_banner (String) published and read back from server. App behavior before/after changes remains to verify; refresh minimum interval is one minute.
- FCM instructions are in fcm-demo.md.
- Student successfully authenticated Firebase CLI. No login code/password is stored in the repository. Direct PowerShell command (avoids script execution-policy restrictions): `& 'D:\PRM\tools\firebase-cli\node_modules\.bin\firebase.cmd' login`.

Official references: https://firebase.google.com/docs/flutter/setup and https://firebase.google.com/docs/crashlytics/android/get-started .

## OAuth update verified

Student enabled Google provider. Refreshed google-services.json supplied by the student was verified and copied to android/app. It contains client types 1 and 3, and its Android certificate hash matches the debug SHA-1 above. The initial no-OAuth configuration described earlier is historical; it has been replaced. No successful user login is claimed yet.

