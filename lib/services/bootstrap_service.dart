import 'package:firebase_core/firebase_core.dart';

import 'telemetry_service.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_service.dart';
import '../firebase_options.dart';

class BootstrapService {
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseTelemetry.installErrorHandlers();
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }
}
