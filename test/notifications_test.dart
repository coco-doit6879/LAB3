import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_mate/models/app_notification.dart';
import 'package:deadline_mate/services/notification_service.dart';
import 'package:deadline_mate/viewmodels/notifications_viewmodel.dart';

class FakeNotifications implements NotificationRepository {
  final inbox = StreamController<List<AppNotification>>.broadcast(sync: true);
  final events = StreamController<NotificationDelivery>.broadcast(sync: true);
  int saves = 0;
  @override
  Stream<List<AppNotification>> watch() => inbox.stream;
  @override
  Stream<NotificationDelivery> deliveries() => events.stream;
  @override
  Future<void> save(AppNotification item) async {
    saves++;
  }

  @override
  Future<void> markRead(String id) async {}
  @override
  Future<String> requestPermission() async => 'denied';
  @override
  Future<String?> token() async => null;
}

void main() {
  test('queued messages for another account never enter inbox or routing', () {
    final service = FirebaseNotificationService('user-b');
    expect(
      service.decode(
        const RemoteMessage(messageId: 'm', data: {'owner_uid': 'user-a'}),
      ),
      isNull,
    );
    final safe = service.decode(
      const RemoteMessage(
        messageId: 'm',
        data: {
          'owner_uid': 'user-b',
          'target_type': 'deadline',
          'target_id': '../foreign',
        },
      ),
    );
    expect(safe?.targetType, 'notifications');
  });
  test('foreground displays without navigation, tap requests route, denied permission is handled', () async {
    final repo = FakeNotifications();
    final vm = NotificationsViewModel(repo);
    const item = AppNotification(
      id: 'm',
      title: 'Nhắc deadline',
      body: 'Sắp đến hạn',
    );
    repo.events.add(const NotificationDelivery(item));
    await Future<void>.delayed(Duration.zero);
    expect(repo.saves, 1);
    expect(vm.foregroundMessage, item);
    expect(vm.pendingOpen, isNull);
    vm.acknowledgeForeground();
    repo.events.add(const NotificationDelivery(item, opened: true));
    await Future<void>.delayed(Duration.zero);
    expect(vm.pendingOpen, item);
    await vm.requestPermission();
    expect(vm.permission, 'denied');
    expect(vm.busy, isFalse);
    vm.dispose();
    await repo.events.close();
    await repo.inbox.close();
  });
}
