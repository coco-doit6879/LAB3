import 'package:firebase_core/firebase_core.dart';

class BootstrapService {
  Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}
