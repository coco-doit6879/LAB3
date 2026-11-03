import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/study_session.dart';
import '../services/study_service.dart';

class StudyViewModel extends ChangeNotifier {
  StudyViewModel(this._repository) {
    retry();
  }
  final StudyRepository _repository;
  StreamSubscription<List<StudySession>>? _subscription;
  bool _disposed = false;
  List<StudySession> _items = [];
  List<StudySession> get items => List.unmodifiable(_items);
  bool loading = true;
  bool busy = false;
  String? error;
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void retry() {
    _subscription?.cancel();
    loading = true;
    error = null;
    _subscription = _repository.watch().listen(
      (value) {
        _items = value;
        loading = false;
        error = null;
        _notify();
      },
      onError: (Object exception) {
        loading = false;
        error = 'Không tải được phiên học. Hãy thử lại.';
        _notify();
      },
    );
    _notify();
  }

  Future<bool> plan(String title, DateTime plannedAt, int minutes) async {
    if (title.trim().isEmpty ||
        title.trim().length > 120 ||
        minutes < 5 ||
        minutes > 180) {
      error = 'Nhập tiêu đề 1–120 ký tự và thời lượng 5–180 phút.';
      _notify();
      return false;
    }
    return _perform(() => _repository.plan(title.trim(), plannedAt, minutes));
  }

  Future<bool> start(String id) => _perform(() => _repository.start(id));
  Future<bool> finish(String id) => _perform(() => _repository.finish(id));
  Future<bool> _perform(Future<void> Function() action) async {
    if (busy || _disposed) return false;
    busy = true;
    error = null;
    _notify();
    try {
      await action();
      return true;
    } catch (_) {
      error = 'Chưa lưu được phiên học. Kiểm tra mạng và tải lại trạng thái.';
      return false;
    } finally {
      busy = false;
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
