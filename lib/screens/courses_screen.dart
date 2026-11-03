import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/courses_viewmodel.dart';
import '../widgets/status_panel.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CoursesViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Môn học')),
      body: vm.loading
          ? const StatusPanel(message: 'Đang tải môn học…', loading: true)
          : vm.error != null
          ? StatusPanel(
              message: vm.error!,
              action: 'Thử lại',
              onAction: vm.retry,
            )
          : vm.items.isEmpty
          ? const StatusPanel(
              message: 'Chưa có môn học. Thêm môn đầu tiên nhé.',
            )
          : ListView(
              padding: const EdgeInsets.all(AppTheme.gap),
              children: vm.items
                  .map(
                    (course) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.book_outlined),
                        title: Text(course.name),
                        subtitle: Text(course.code),
                      ),
                    ),
                  )
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const _CourseDialog(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Thêm môn học'),
      ),
    );
  }
}

class _CourseDialog extends StatefulWidget {
  const _CourseDialog();
  @override
  State<_CourseDialog> createState() => _CourseDialogState();
}

class _CourseDialogState extends State<_CourseDialog> {
  final _name = TextEditingController();
  final _code = TextEditingController();
  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CoursesViewModel>();
    return PopScope(
      canPop: !vm.busy,
      child: AlertDialog(
        title: const Text('Thêm môn học'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _name,
                enabled: !vm.busy,
                maxLength: 80,
                decoration: const InputDecoration(labelText: 'Tên môn'),
              ),
              TextField(
                controller: _code,
                enabled: !vm.busy,
                maxLength: 20,
                decoration: const InputDecoration(labelText: 'Mã môn'),
              ),
              if (vm.error != null) Text(vm.error!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: vm.busy ? null : () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: vm.busy
                ? null
                : () async {
                    final success = await vm.create(_name.text, _code.text);
                    if (success && context.mounted) Navigator.of(context).pop();
                  },
            child: Text(vm.busy ? 'Đang lưu…' : 'Thêm môn học'),
          ),
        ],
      ),
    );
  }
}
