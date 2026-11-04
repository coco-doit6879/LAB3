import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';
import 'telemetry_service.dart';

abstract interface class AuthRepository {
  Stream<AppUser?> get changes;
  Future<void> signIn();
  Future<void> signOut();
}

class GoogleAuthService implements AuthRepository {
  final _auth = FirebaseAuth.instance;
  Future<void>? _initialization;
  @override
  Stream<AppUser?> get changes =>
      _auth.authStateChanges().asyncMap((user) async {
        await FirebaseTelemetry.identify(user?.uid);
        return user == null
            ? null
            : AppUser(
                uid: user.uid,
                name: user.displayName,
                email: user.email,
                photoUrl: user.photoURL,
              );
      });
  @override
  Future<void> signIn() async {
    if (kIsWeb) {
      await _auth.signInWithPopup(GoogleAuthProvider());
      await FirebaseTelemetry().event('login', {'method': 'google'});
      return;
    }
    await (_initialization ??= GoogleSignIn.instance.initialize());
    final account = await GoogleSignIn.instance.authenticate();
    final token = account.authentication.idToken;
    if (token == null) throw StateError('Missing Google ID token');
    await _auth.signInWithCredential(
      GoogleAuthProvider.credential(idToken: token),
    );
    await FirebaseTelemetry().event('login', {'method': 'google'});
  }

  @override
  Future<void> signOut() async {
    // Firebase is the authority: do not keep access if Google cleanup fails.
    await _auth.signOut();
    await FirebaseTelemetry().event('logout');
    if (_initialization != null) await GoogleSignIn.instance.signOut();
  }
}
