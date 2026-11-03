import 'package:flutter/foundation.dart';

import '../services/bootstrap_service.dart';

class BootstrapViewModel extends ChangeNotifier {
  BootstrapViewModel(this._service);
  final BootstrapService _service;
  bool loading = false;
  bool _disposed = false;
  bool ready = false;
  String? error;
  Future<void> initialize() async {
    if (loading || _disposed) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      await _service.initialize();
      ready = true;
    } catch (_) {
      ready = false;
      error = 'Chưa kết nối được Firebase. Hãy kiểm tra mạng và cấu hình dự án Android.';
    } finally {
      loading = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
