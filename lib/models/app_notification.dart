class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.targetId,
    this.targetType = 'notifications',
    this.read = false,
  });
  final String id;
  final String title;
  final String body;
  final String? targetId;
  final String targetType;
  final bool read;
}

class NotificationDelivery {
  const NotificationDelivery(this.item, {this.opened = false});
  final AppNotification item;
  final bool opened;
}
