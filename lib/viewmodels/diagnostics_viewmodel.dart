import 'package:flutter/foundation.dart';

import '../services/telemetry_service.dart';

class DiagnosticsViewModel extends ChangeNotifier {
  final Telemetry _telemetry = FirebaseTelemetry();
  bool busy = false;
  bool _disposed = false;
  String? message;
  bool get supported => !kIsWeb;
  bool get canCrash => kDebugMode && supported;
  Future<void> handledDemo() async {
    if (!supported) return;
    if (busy) return;
    busy = true;
    notifyListeners();
    await _telemetry.handled('profile_demo');
    message = 'Đã yêu cầu ghi lỗi thử nghiệm. Kiểm tra Crashlytics Console để xác nhận nhận được.';
    busy = false;
    if (!_disposed) notifyListeners();
  }

  void crashDemo() => FirebaseTelemetry.testCrash();
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
