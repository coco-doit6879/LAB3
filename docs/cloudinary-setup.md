# Cloudinary PDF storage

The student selected Cloudinary to avoid linking a payment method. Firebase remains responsible for authentication, Firestore metadata, notifications, Remote Config, Analytics and Crashlytics.

Public build configuration is in `config/cloudinary.json`. It contains no API secret. Never add a Cloudinary API secret to a Flutter application.

Build from the project directory:

```powershell
D:\PRM\tools\flutter\bin\flutter.bat build apk --debug --dart-define-from-file=config/cloudinary.json
```

## Console verification

Observed on 2026-11-03: cloud name `dg5wyuwkp`; saved preset `deadline_mate_pdf`; Unsigned; overwrite disabled; generated public IDs; asset folder `deadline_mate/reports`.

Current editor inspection: Optimize and Deliver → Allowed formats is blank. The student must enter `pdf` there and save; leave the separate Format conversion field empty. This format restriction is not yet saved or verified.

Correction to earlier setup instructions: presets do **not** support a per-preset maximum file size. The application checks the PDF header and a 10485760-byte (10 MiB) cap before sending a request; account-wide server limits still apply. This client limit can be bypassed by a separate uploader and must not be described as server-side enforcement. See the official [upload preset documentation](https://cloudinary.com/documentation/upload_presets), Best practices → Security. No real upload or download has been verified yet.

The adapter uploads bytes to the raw upload endpoint and accepts only HTTPS Cloudinary raw delivery URLs for the configured cloud. Firestore stores the returned URL, public ID, provider and owner ID. A file can remain in Cloudinary if uploading succeeds but saving Firestore metadata fails. Unsigned uploads do not authorize deleting arbitrary assets; clean such orphan files manually in Media Library. The app does not embed privileged deletion credentials.

Cloudinary delivery URLs are public bearer links, even though Firestore metadata is owner scoped. Use synthetic coursework data in the demonstration; this implementation does not provide private document delivery.

## Verification completed locally

- Flutter analysis: clean; latest recorded full suite has 22 passing tests (see test-report.md). Adapter checks include multipart upload contract, rejection handling, URL validation, missing configuration, invalid PDF header and oversized PDF rejection before HTTP.
- 18 emulator security rules tests passed: 11 Firestore and 7 Storage. Storage rules remain tested as an optional Firebase alternative; the active PDF adapter is Cloudinary.
- These adapter checks do not establish that PDF upload works against the live project. Google sign-in and Firestore course/deadline/study flows have separate live evidence in live-flow-results.md; deployment evidence is in backend-deployment.md.
