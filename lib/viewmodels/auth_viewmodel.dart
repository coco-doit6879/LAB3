import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository) {
    _subscription = _repository.changes.listen(
      (value) {
        user = value;
        initializing = false;
        _notify();
      },
      onError: (Object exception) {
        user = null;
        initializing = false;
        error = 'Không xác minh được phiên đăng nhập. Hãy thử lại.';
        _notify();
      },
    );
  }
  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _subscription;
  bool _disposed = false;
  AppUser? user;
  bool initializing = true;
  bool busy = false;
  String? error;
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> signIn() => _perform(
    _repository.signIn,
    'Chưa đăng nhập được hoặc bạn đã hủy. Kiểm tra mạng và thử lại khi sẵn sàng.',
  );
  Future<void> signOut() =>
      _perform(_repository.signOut, 'Đăng xuất gặp lỗi. Hãy thử lại.');
  Future<void> _perform(Future<void> Function() action, String message) async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    _notify();
    try {
      await action();
    } catch (_) {
      error = message;
    } finally {
      busy = false;
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription.cancel();
    super.dispose();
  }
}
