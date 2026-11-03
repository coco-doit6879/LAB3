import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../services/course_service.dart';

class CoursesViewModel extends ChangeNotifier {
  CoursesViewModel(this._repository) {
    retry();
  }
  final CourseRepository _repository;
  StreamSubscription<List<Course>>? _subscription;
  bool _disposed = false;
  List<Course> _items = [];
  List<Course> get items => List.unmodifiable(_items);
  Map<String, String> get labels => Map.unmodifiable({
    for (final course in _items) course.id: '${course.code} — ${course.name}',
  });
  String labelFor(String id) =>
      labels[id] ??
      (loading ? 'Đang tải môn học…' : 'Môn học không còn khả dụng');
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
        error = 'Không tải được môn học.';
        _notify();
      },
    );
    _notify();
  }

  Future<bool> create(String name, String code) async {
    if (busy || _disposed) return false;
    if (name.trim().isEmpty ||
        name.trim().length > 80 ||
        code.trim().isEmpty ||
        code.trim().length > 20) {
      error = 'Tên môn cần 1–80 ký tự; mã môn cần 1–20 ký tự.';
      _notify();
      return false;
    }
    busy = true;
    error = null;
    _notify();
    try {
      await _repository.create(name.trim(), code.trim());
      return true;
    } catch (_) {
      error = 'Chưa tạo được môn học. Hãy thử lại.';
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
