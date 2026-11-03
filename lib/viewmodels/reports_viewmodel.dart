import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/deadline.dart';
import '../models/report.dart';
import '../services/report_service.dart';
import '../services/file_storage_service.dart';
import '../services/telemetry_service.dart';

class ReportsViewModel extends ChangeNotifier {
  ReportsViewModel(this._repository, {this._telemetry = const NoTelemetry()}) {
    retry();
  }
  final ReportRepository _repository;
  final Telemetry _telemetry;
  StreamSubscription<List<Report>>? _subscription;
  bool _disposed = false;
  List<Report> _items = [];
  List<Report> get items => List.unmodifiable(_items);
  bool loading = true;
  bool busy = false;
  double progress = 0;
  String? error;
  String? success;
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
        _notify();
      },
      onError: (Object exception) {
        loading = false;
        error = 'Không tải được lịch sử báo cáo.';
        _notify();
      },
    );
    _notify();
  }

  Future<void> export(
    List<Deadline> items, {
    required bool enabled,
    Map<String, String> courseLabels = const {},
  }) async {
    if (busy || _disposed) return;
    if (!enabled) {
      error = 'Xuất PDF đang tắt theo cấu hình từ xa.';
      _notify();
      return;
    }
    busy = true;
    progress = 0;
    error = null;
    success = null;
    _notify();
    try {
      await _repository.export(List.unmodifiable(items), (value) {
        progress = value;
        _notify();
      }, courseLabels: Map.unmodifiable(courseLabels));
      success = 'Đã tải PDF lên và lưu thông tin báo cáo.';
      await _telemetry.event('export_pdf', {'item_count': items.length});
    } catch (exception) {
      await _telemetry.handled('pdf_export');
      error = exception is StorageConfigurationException
          ? 'Tính năng xuất báo cáo chưa được cấu hình.'
          : 'Chưa xuất được PDF. Kiểm tra kết nối rồi thử lại.';
    } finally {
      busy = false;
      _notify();
    }
  }

  Future<void> open(Report item) async {
    try {
      await _repository.open(item.url);
    } catch (_) {
      error = 'Không mở được báo cáo. Hãy kiểm tra kết nối và đường dẫn.';
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
