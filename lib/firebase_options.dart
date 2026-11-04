// Public configuration from the official Firebase Android and Web app registrations.
// These are public app identifiers; access control is enforced by Security Rules.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('Deadline Mate supports Android and Web.');
    }
    return android;
  }

  static const web = FirebaseOptions(
    apiKey: 'AIzaSyDwhx8PhHI5ouiNbr6h5khokwayPFLzSD8',
    appId: '1:106147478931:web:5c79d7763400c99037fc66',
    messagingSenderId: '106147478931',
    projectId: 'deadline-mate-feff4',
    authDomain: 'deadline-mate-feff4.firebaseapp.com',
    storageBucket: 'deadline-mate-feff4.firebasestorage.app',
    measurementId: 'G-WYQ938TESQ',
  );

  static const android = FirebaseOptions(
    apiKey: "AIzaSyCpqahTlQ7dRkh26iTt-gnebUy0HI652PY",
    appId: "1:106147478931:android:1c1cb783766a35d837fc66",
    messagingSenderId: "106147478931",
    projectId: "deadline-mate-feff4",
    storageBucket: "deadline-mate-feff4.firebasestorage.app",
  );
}
