import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';
import '../services/notification_service.dart';

class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel(this._repository) {
    retry();
    _deliverySubscription = _repository.deliveries().listen(
      _receive,
      onError: (Object exception) {
        error = 'Chưa nhận được thông báo. Kiểm tra cấu hình FCM.';
        _notify();
      },
    );
  }
  final NotificationRepository _repository;
  StreamSubscription<List<AppNotification>>? _subscription;
  StreamSubscription<NotificationDelivery>? _deliverySubscription;
  bool _disposed = false;
  List<AppNotification> _items = [];
  List<AppNotification> get items => List.unmodifiable(_items);
  bool loading = true;
  bool busy = false;
  String? error;
  String permission = 'Chưa yêu cầu';
  String? deviceToken;
  AppNotification? pendingOpen;
  AppNotification? foregroundMessage;
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
        error = 'Không tải được lịch sử thông báo.';
        _notify();
      },
    );
    _notify();
  }

  Future<void> _receive(NotificationDelivery delivery) async {
    try {
      await _repository.save(delivery.item);
    } catch (_) {
      error = 'Đã nhận thông báo nhưng chưa lưu được lịch sử.';
    }
    if (_disposed) return;
    if (delivery.opened) {
      pendingOpen = delivery.item;
    } else {
      foregroundMessage = delivery.item;
    }
    _notify();
  }

  Future<void> open(AppNotification item) async {
    try {
      await _repository.markRead(item.id);
    } catch (_) {
      error = 'Chưa cập nhật được trạng thái đã đọc.';
    }
    if (_disposed) return;
    pendingOpen = item;
    _notify();
  }

  void acknowledgeOpen() {
    pendingOpen = null;
  }

  void acknowledgeForeground() {
    foregroundMessage = null;
  }

  Future<void> requestPermission() async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    _notify();
    try {
      permission = await _repository.requestPermission();
      deviceToken = await _repository.token();
    } catch (_) {
      error = 'Chưa lấy được quyền hoặc token thông báo. Bạn có thể thử lại.';
    } finally {
      busy = false;
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    _deliverySubscription?.cancel();
    super.dispose();
  }
}
