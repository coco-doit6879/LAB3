import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/deadlines_viewmodel.dart';
import '../widgets/status_panel.dart';
import 'deadline_form_screen.dart';

class DeadlineDetailScreen extends StatelessWidget {
  const DeadlineDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DeadlinesViewModel>();
    final item = vm.items.where((item) => item.id == id).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết deadline')),
      body: item == null
          ? StatusPanel(
              message: vm.loading ? 'Đang tải…' : 'Deadline không còn tồn tại.',
              loading: vm.loading,
              action: 'Quay lại',
              onAction: () => Navigator.of(context).pop(),
            )
          : ListView(
              padding: const EdgeInsets.all(AppTheme.wideGap),
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppTheme.gap),
                Text('Môn học: ${item.courseId}'),
                Text(
                  'Hạn: ${DateFormat('dd/MM/yyyy HH:mm').format(item.dueAt)}',
                ),
                Text(item.completed ? 'Đã hoàn thành' : 'Chưa hoàn thành'),
                const SizedBox(height: AppTheme.wideGap),
                if (vm.error != null) Text(vm.error!),
                FilledButton.icon(
                  onPressed: vm.saving
                      ? null
                      : () =>
                            vm.save(item.copyWith(completed: !item.completed)),
                  icon: const Icon(Icons.check),
                  label: Text(
                    item.completed
                        ? 'Đánh dấu chưa xong'
                        : 'Hoàn thành deadline',
                  ),
                ),
                OutlinedButton(
                  onPressed: vm.saving
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DeadlineFormScreen(item: item),
                          ),
                        ),
                  child: const Text('Sửa deadline'),
                ),
                TextButton(
                  onPressed: vm.saving
                      ? null
                      : () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xóa deadline?'),
                              content: const Text(
                                'Thao tác này không thể hoàn tác.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Giữ lại'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                          final success = await vm.remove(id);
                          if (success && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                  child: const Text('Xóa deadline'),
                ),
              ],
            ),
    );
  }
}
