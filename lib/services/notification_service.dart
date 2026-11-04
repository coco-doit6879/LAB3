import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null || message.data['owner_uid'] != uid) return;
  final service = FirebaseNotificationService(uid);
  final item = service.decode(message);
  if (item != null) await service.save(item);
}

abstract interface class NotificationRepository {
  Stream<List<AppNotification>> watch();
  Stream<NotificationDelivery> deliveries();
  Future<void> save(AppNotification item);
  Future<void> markRead(String id);
  Future<String> requestPermission();
  Future<String?> token();
}

class FirebaseNotificationService implements NotificationRepository {
  FirebaseNotificationService(this.uid);
  final String uid;
  CollectionReference<Map<String, dynamic>> get _items => FirebaseFirestore
      .instance
      .collection('users')
      .doc(uid)
      .collection('notifications');
  AppNotification? decode(RemoteMessage message) {
    if (message.data['owner_uid'] != uid) return null;
    final id = message.messageId;
    if (id == null) return null;
    final type = message.data['target_type'];
    final targetId = message.data['target_id'];
    return AppNotification(
      id: Uri.encodeComponent(id),
      title: (message.notification?.title ?? 'Deadline Mate').substring(
        0,
        (message.notification?.title ?? 'Deadline Mate').length.clamp(0, 200),
      ),
      body: (message.notification?.body ?? '').substring(
        0,
        (message.notification?.body ?? '').length.clamp(0, 2000),
      ),
      targetType:
          type == 'deadline' &&
              targetId is String &&
              targetId.isNotEmpty &&
              targetId.length <= 200 &&
              !targetId.contains('/')
          ? 'deadline'
          : 'notifications',
      targetId: targetId is String ? targetId : null,
    );
  }

  @override
  Stream<NotificationDelivery> deliveries() {
    // Web preview retains the Firestore inbox; browser push needs a separately
    // configured service worker and VAPID key before it can be enabled.
    if (kIsWeb) return const Stream.empty();
    late final StreamController<NotificationDelivery> controller;
    StreamSubscription<RemoteMessage>? foreground;
    StreamSubscription<RemoteMessage>? opened;
    void emit(RemoteMessage message, bool tapped) {
      final item = decode(message);
      if (item != null && !controller.isClosed) {
        controller.add(NotificationDelivery(item, opened: tapped));
      }
    }

    controller = StreamController<NotificationDelivery>(
      onListen: () {
        foreground = FirebaseMessaging.onMessage.listen(
          (message) => emit(message, false),
        );
        opened = FirebaseMessaging.onMessageOpenedApp.listen(
          (message) => emit(message, true),
        );
        FirebaseMessaging.instance
            .getInitialMessage()
            .then((message) {
              if (message != null) emit(message, true);
            })
            .catchError((Object error) {
              if (!controller.isClosed) controller.addError(error);
            });
      },
      onCancel: () async {
        await foreground?.cancel();
        await opened?.cancel();
      },
    );
    return controller.stream;
  }

  @override
  Stream<List<AppNotification>> watch() => _items
      .orderBy('receivedAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) {
              final d = doc.data();
              return AppNotification(
                id: doc.id,
                title: d['title'] as String,
                body: d['body'] as String,
                targetType: d['targetType'] as String,
                targetId: d['targetId'] as String?,
                read: d['read'] as bool,
              );
            })
            .toList(growable: false),
      );
  @override
  Future<void> save(AppNotification item) async {
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final doc = _items.doc(item.id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      if ((await transaction.get(doc)).exists) return;
      transaction.set(doc, {
        'title': item.title,
        'body': item.body,
        'targetType': item.targetType,
        'targetId': item.targetId,
        'read': false,
        'receivedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<void> markRead(String id) => _items.doc(id).update({'read': true});
  @override
  Future<String> requestPermission() async => kIsWeb
      ? 'Chưa cấu hình thông báo trình duyệt'
      : (await FirebaseMessaging.instance.requestPermission())
            .authorizationStatus
            .name;
  @override
  Future<String?> token() {
    if (kIsWeb) return Future.value(null);
    // Console test messages require the legacy registration token, not an FID.
    // Keep this compatibility call until Console support for direct-send FIDs is verified.
    // ignore: deprecated_member_use
    return FirebaseMessaging.instance.getToken();
  }
}
