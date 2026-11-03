import '../widgets/app_dialog.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_button.dart';
import '../widgets/app_field.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/study_session.dart';
import '../theme/app_theme.dart';
import '../viewmodels/study_viewmodel.dart';
import '../widgets/status_panel.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();
    return Scaffold(
      appBar: AppTopBar(title: const Text('Phiên học')),
      body: vm.loading
          ? const StatusPanel(message: 'Đang tải phiên học…', loading: true)
          : Column(
              children: [
                if (vm.error != null)
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.gap),
                    child: Column(
                      children: [
                        Text(vm.error!),
                        TextButton(
                          onPressed: vm.retry,
                          child: const Text('Tải lại'),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: vm.items.isEmpty
                      ? const StatusPanel(
                          message:
                              'Lập phiên học đầu tiên để bắt đầu tập trung.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppTheme.gap),
                          itemCount: vm.items.length,
                          itemBuilder: (context, index) {
                            final item = vm.items[index];
                            final status = switch (item.status) {
                              SessionStatus.planned => 'Đã lên kế hoạch',
                              SessionStatus.running => 'Đang học',
                              SessionStatus.completed =>
                                'Đã kết thúc · ${item.elapsed(DateTime.now()).inMinutes} phút',
                            };
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.gap),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    Text(
                                      '${DateFormat('dd/MM HH:mm').format(item.plannedAt)} · ${item.plannedMinutes} phút',
                                    ),
                                    Text(status),
                                    if (item.status == SessionStatus.planned)
                                      AppButton(
                                        onPressed: vm.busy
                                            ? null
                                            : () => vm.start(item.id),
                                        child: const Text('Bắt đầu học'),
                                      ),
                                    if (item.status == SessionStatus.running)
                                      AppButton(
                                        onPressed: vm.busy
                                            ? null
                                            : () async {
                                                final confirmed =
                                                    await showDialog<bool>(
                                                      useRootNavigator: false,
                                                      context: context,
                                                      builder: (context) => AppDialog(
                                                        title: const Text(
                                                          'Kết thúc phiên học?',
                                                        ),
                                                        content: const Text(
                                                          'Thời gian thực tế sẽ được lưu vào lịch sử.',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                  false,
                                                                ),
                                                            child: const Text(
                                                              'Học tiếp',
                                                            ),
                                                          ),
                                                          AppButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                  true,
                                                                ),
                                                            child: const Text(
                                                              'Kết thúc',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                if (confirmed == true) {
                                                  await vm.finish(item.id);
                                                }
                                              },
                                        child: const Text('Kết thúc phiên học'),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: vm.busy
            ? null
            : () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  settings: const RouteSettings(name: 'plan_session'),
                  builder: (_) => const _PlanSessionScreen(),
                ),
              ),
        icon: const Icon(Icons.add),
        label: const Text('Lập phiên học'),
      ),
    );
  }
}

class _PlanSessionScreen extends StatefulWidget {
  const _PlanSessionScreen();
  @override
  State<_PlanSessionScreen> createState() => _PlanSessionScreenState();
}

class _PlanSessionScreenState extends State<_PlanSessionScreen> {
  final _title = TextEditingController();
  final _minutes = TextEditingController(text: '25');
  DateTime _plannedAt = DateTime.now();
  @override
  void dispose() {
    _title.dispose();
    _minutes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();
    return Scaffold(
      appBar: AppTopBar(title: const Text('Lập phiên học')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.wideGap),
        children: [
          AppField(
            controller: _title,
            enabled: !vm.busy,
            maxLength: 120,
            decoration: const InputDecoration(labelText: 'Bạn sẽ học gì?'),
          ),
          AppField(
            controller: _minutes,
            enabled: !vm.busy,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Thời lượng dự kiến (phút)',
            ),
          ),
          OutlinedButton(
            onPressed: vm.busy
                ? null
                : () async {
                    final date = await showDatePicker(
                      useRootNavigator: false,
                      context: context,
                      initialDate: _plannedAt,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date == null || !context.mounted) return;
                    final time = await showTimePicker(
                      useRootNavigator: false,
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_plannedAt),
                    );
                    if (time != null && mounted) {
                      setState(
                        () => _plannedAt = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        ),
                      );
                    }
                  },
            child: Text(DateFormat('dd/MM/yyyy HH:mm').format(_plannedAt)),
          ),
          if (vm.error != null) Text(vm.error!),
          AppButton(
            loading: vm.busy,
            onPressed: vm.busy
                ? null
                : () async {
                    final success = await vm.plan(
                      _title.text,
                      _plannedAt,
                      int.tryParse(_minutes.text) ?? 0,
                    );
                    if (success && context.mounted) Navigator.of(context).pop();
                  },
            child: Text(vm.busy ? 'Đang lưu…' : 'Lưu phiên học'),
          ),
        ],
      ),
    );
  }
}
