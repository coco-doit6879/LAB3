# FCM demonstration setup

Project: deadline-mate-feff4. App display name: Deadline Mate.

1. Sign in on Android. In Profile, request notification permission and obtain the registration token.
2. Use Firebase Console Messaging to send a test message to that token.
3. Add custom data: owner_uid = the current Firebase Auth UID; target_type = deadline; target_id = an existing deadline document ID belonging to that UID.
4. Messages without matching owner_uid are deliberately ignored by the app inbox/router. This prevents a queued notification for a previous user from becoming another user's private inbox item.
5. Foreground: verify the in-app banner/snackbar and Notification Center. Background: verify Android notification and tap routing. Closed app: reopen from notification and verify the relevant detail. Repeat after denying permission.
6. A removed deadline falls back to the not-found screen with Back. Unknown target types open Notification Center; external URLs are never executed from a payload.

Do not publish device registration tokens in screenshots. SDK 17 retains getToken as a deprecated compatibility method; this app uses it intentionally for Console test messages until the Console's FID target support is verified. Delivery, background behavior and persistence still require an actual device run.

There is no scheduler backend: this is Console-sent topic-relevant push, not a claim of automatic time-based reminders.
