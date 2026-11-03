import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/deadline.dart';
import '../services/deadline_repository.dart';
import '../services/telemetry_service.dart';

enum DeadlineFilter { all, pending, completed }

class DeadlinesViewModel extends ChangeNotifier {
  DeadlinesViewModel(
    this._repository, {
    this._telemetry = const NoTelemetry(),
  }) {
    retry();
  }
  final DeadlineRepository _repository;
  final Telemetry _telemetry;
  void recordView(String id) =>
      _telemetry.event('view_deadline', {'item_id': id});
  StreamSubscription<List<Deadline>>? _subscription;
  bool _disposed = false;
  List<Deadline> _items = [];
  List<Deadline> get items => List.unmodifiable(_items);
  bool loading = true;
  bool saving = false;
  String? error;
  DeadlineFilter filter = DeadlineFilter.all;
  List<Deadline> get visible => _items
      .where(
        (item) => switch (filter) {
          DeadlineFilter.all => true,
          DeadlineFilter.pending => !item.completed,
          DeadlineFilter.completed => item.completed,
        },
      )
      .toList(growable: false);

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void setFilter(DeadlineFilter value) {
    filter = value;
    _notify();
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
        error = 'Không tải được deadline. Kiểm tra kết nối và thử lại.';
        _notify();
      },
    );
    _notify();
  }

  Future<bool> save(Deadline item) async {
    final validation = Deadline.validateTitle(item.title);
    if (validation != null || item.courseId.trim().isEmpty) {
      error = validation ?? 'Chọn môn học.';
      _notify();
      return false;
    }
    return _perform(() async {
      if (item.id.isEmpty) {
        final id = await _repository.create(item);
        await _telemetry.event('create_deadline', {'item_id': id});
      } else {
        await _repository.update(item);
        await _telemetry.event('update_deadline', {'item_id': item.id});
      }
    });
  }

  Future<bool> remove(String id) => _perform(() async {
    await _repository.delete(id);
    await _telemetry.event('delete_deadline', {'item_id': id});
  });
  Future<bool> _perform(Future<void> Function() action) async {
    if (saving || _disposed) return false;
    saving = true;
    error = null;
    _notify();
    try {
      await action();
      return true;
    } catch (_) {
      await _telemetry.handled('deadline_write');
      error = 'Chưa lưu được thay đổi. Hãy thử lại.';
      return false;
    } finally {
      saving = false;
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
