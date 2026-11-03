# Cloudinary PDF storage

The student selected Cloudinary to avoid linking a payment method. Firebase remains responsible for authentication, Firestore metadata, notifications, Remote Config, Analytics and Crashlytics.

Public build configuration is in `config/cloudinary.json`. It contains no API secret. Never add a Cloudinary API secret to a Flutter application.

Build from the project directory:

```powershell
D:\PRM\tools\flutter\bin\flutter.bat build apk --debug --dart-define-from-file=config/cloudinary.json
```

## Console verification

Observed on 2026-11-03: cloud name `dg5wyuwkp`; saved preset `deadline_mate_pdf`; Unsigned; overwrite disabled; generated public IDs; asset folder `deadline_mate/reports`.

Still to verify in the preset editor: allowed formats `pdf` only and maximum file size 10485760 bytes (10 MiB). The application also checks the PDF header and size before sending a request, but server restrictions must be checked independently. No real upload or download has been verified yet.

The adapter uploads bytes to the raw upload endpoint and accepts only HTTPS Cloudinary raw delivery URLs for the configured cloud. Firestore stores the returned URL, public ID, provider and owner ID. A file can remain in Cloudinary if uploading succeeds but saving Firestore metadata fails. Unsigned uploads do not authorize deleting arbitrary assets; clean such orphan files manually in Media Library. The app does not embed privileged deletion credentials.

Cloudinary delivery URLs are public bearer links, even though Firestore metadata is owner scoped. Use synthetic coursework data in the demonstration; this implementation does not provide private document delivery.

## Verification completed locally

- Flutter analysis: clean; 16 Flutter tests passed, including multipart upload contract, rejection handling, URL validation and missing configuration.
- 18 emulator security rules tests passed: 11 Firestore and 7 Storage. Storage rules remain tested as an optional Firebase alternative; the active PDF adapter is Cloudinary.
- These checks do not establish that Google sign-in, cloud Firestore deployment or PDF upload works against the live project.
