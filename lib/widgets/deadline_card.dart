import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/deadline.dart';
import '../theme/app_theme.dart';

/// Shared deadline summary. State is expressed with both an icon and text.
class DeadlineCard extends StatelessWidget {
  const DeadlineCard({super.key, required this.deadline, required this.onTap});

  final Deadline deadline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(AppTheme.gap),
      leading: Icon(
        deadline.completed ? Icons.check_circle_outline : Icons.schedule,
      ),
      title: Text(deadline.title),
      subtitle: Text(
        '${deadline.courseId} · ${DateFormat('dd/MM/yyyy HH:mm').format(deadline.dueAt)}\n'
        '${deadline.completed ? 'Đã hoàn thành' : 'Chưa hoàn thành'}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}
