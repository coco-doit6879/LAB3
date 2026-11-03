// Generated from the official Firebase Android configuration downloaded from Console.
// These are public app identifiers; access control is enforced by Security Rules.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('Deadline Mate is configured for Android only.');
    }
    return android;
  }

  static const android = FirebaseOptions(
    apiKey: "AIzaSyCpqahTlQ7dRkh26iTt-gnebUy0HI652PY",
    appId: "1:106147478931:android:1c1cb783766a35d837fc66",
    messagingSenderId: "106147478931",
    projectId: "deadline-mate-feff4",
    storageBucket: "deadline-mate-feff4.firebasestorage.app",
  );
}
