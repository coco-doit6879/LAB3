import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/notifications_viewmodel.dart';
import '../widgets/status_panel.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationsViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: vm.loading
          ? const StatusPanel(message: 'Đang tải thông báo…', loading: true)
          : Column(
              children: [
                if (vm.error != null) Text(vm.error!),
                TextButton(onPressed: vm.retry, child: const Text('Tải lại')),
                Expanded(
                  child: vm.items.isEmpty
                      ? const StatusPanel(message: 'Chưa có thông báo.')
                      : ListView(
                          padding: const EdgeInsets.all(AppTheme.gap),
                          children: vm.items
                              .map(
                                (item) => Card(
                                  child: ListTile(
                                    leading: Icon(
                                      item.read
                                          ? Icons.drafts_outlined
                                          : Icons.mark_email_unread_outlined,
                                    ),
                                    title: Text(item.title),
                                    subtitle: Text(item.body),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      vm.open(item);
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ],
            ),
    );
  }
}
