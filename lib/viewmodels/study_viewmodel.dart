import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/study_session.dart';
import '../services/study_service.dart';
import '../services/telemetry_service.dart';

class StudyViewModel extends ChangeNotifier {
  StudyViewModel(this._repository, {this._telemetry = const NoTelemetry()}) {
    retry();
  }
  final StudyRepository _repository;
  final Telemetry _telemetry;
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

  String allocateDraftId() => _repository.allocateId();

  Future<bool> plan(
    String id,
    String title,
    DateTime plannedAt,
    int minutes,
  ) async {
    if (id.isEmpty ||
        title.trim().isEmpty ||
        title.trim().length > 120 ||
        minutes < 5 ||
        minutes > 180) {
      error = 'Nhập tiêu đề 1–120 ký tự và thời lượng 5–180 phút.';
      _notify();
      return false;
    }
    return _perform(
      () => _repository.plan(id, title.trim(), plannedAt, minutes),
    );
  }

  Future<bool> start(String id) => _perform(() async {
    await _repository.start(id);
    await _telemetry.event('start_study_session', {'session_id': id});
  });
  Future<bool> finish(String id) => _perform(() async {
    await _repository.finish(id);
    await _telemetry.event('complete_study_session', {'session_id': id});
  });
  Future<bool> _perform(Future<void> Function() action) async {
    if (busy || _disposed) return false;
    busy = true;
    error = null;
    _notify();
    try {
      await action();
      return true;
    } catch (_) {
      await _telemetry.handled('study_write');
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
