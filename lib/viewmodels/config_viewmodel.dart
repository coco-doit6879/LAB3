import 'package:flutter/foundation.dart';

import '../services/config_service.dart';

class ConfigViewModel extends ChangeNotifier {
  ConfigViewModel(this._repository);
  final ConfigRepository _repository;
  AppConfig config = const AppConfig();
  bool busy = false;
  bool _disposed = false;
  String? error;
  Future<void> refresh() async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      config = await _repository.fetch();
    } catch (_) {
      error = 'Chưa tải được cấu hình mới. Đang dùng giá trị mặc định hoặc lần tải thành công trước.';
    } finally {
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
