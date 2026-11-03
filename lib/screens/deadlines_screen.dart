import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/deadlines_viewmodel.dart';
import '../widgets/status_panel.dart';
import 'deadline_detail_screen.dart';
import 'deadline_form_screen.dart';
import 'profile_screen.dart';

class DeadlinesScreen extends StatelessWidget {
  const DeadlinesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DeadlinesViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deadline của bạn'),
        actions: [
          IconButton(
            tooltip: 'Hồ sơ',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.gap),
            child: SegmentedButton<DeadlineFilter>(
              segments: const [
                ButtonSegment(value: DeadlineFilter.all, label: Text('Tất cả')),
                ButtonSegment(
                  value: DeadlineFilter.pending,
                  label: Text('Chưa xong'),
                ),
                ButtonSegment(
                  value: DeadlineFilter.completed,
                  label: Text('Đã xong'),
                ),
              ],
              selected: {vm.filter},
              onSelectionChanged: (values) => vm.setFilter(values.first),
            ),
          ),
          Expanded(
            child: vm.loading
                ? const StatusPanel(
                    message: 'Đang tải deadline…',
                    loading: true,
                  )
                : vm.error != null
                ? StatusPanel(
                    message: vm.error!,
                    action: 'Thử lại',
                    onAction: vm.retry,
                  )
                : vm.visible.isEmpty
                ? StatusPanel(
                    message: 'Chưa có deadline phù hợp.',
                    action: 'Tạo deadline',
                    onAction: () => _create(context),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.gap),
                    itemCount: vm.visible.length,
                    itemBuilder: (context, index) {
                      final item = vm.visible[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            item.completed
                                ? Icons.check_circle_outline
                                : Icons.schedule,
                          ),
                          title: Text(item.title),
                          subtitle: Text(
                            '${item.courseId} · ${DateFormat('dd/MM/yyyy HH:mm').format(item.dueAt)}\n${item.completed ? 'Đã hoàn thành' : 'Chưa hoàn thành'}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => DeadlineDetailScreen(id: item.id),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context),
        icon: const Icon(Icons.add),
        label: const Text('Tạo deadline'),
      ),
    );
  }

  void _create(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const DeadlineFormScreen()));
}
