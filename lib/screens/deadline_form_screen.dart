import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/deadline.dart';
import '../theme/app_theme.dart';
import '../viewmodels/deadlines_viewmodel.dart';
import '../viewmodels/courses_viewmodel.dart';
import 'courses_screen.dart';

class DeadlineFormScreen extends StatefulWidget {
  const DeadlineFormScreen({super.key, this.item});
  final Deadline? item;
  @override
  State<DeadlineFormScreen> createState() => _DeadlineFormScreenState();
}

class _DeadlineFormScreenState extends State<DeadlineFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _course;
  late DateTime _due;
  late final DateTime _originalDue;
  bool _saved = false;
  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.item?.title ?? '')
      ..addListener(_changed);
    _course = TextEditingController(text: widget.item?.courseId ?? '')
      ..addListener(_changed);
    _due = widget.item?.dueAt ?? DateTime.now().add(const Duration(days: 1));
    _originalDue = _due;
  }

  void _changed() => setState(() {});
  bool get _dirty =>
      _title.text != (widget.item?.title ?? '') ||
      _course.text != (widget.item?.courseId ?? '') ||
      _due != _originalDue;
  @override
  void dispose() {
    _title.dispose();
    _course.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DeadlinesViewModel>();
    final courses = context.watch<CoursesViewModel>();
    return PopScope(
      canPop: _saved || (!_dirty && !vm.saving),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || vm.saving) return;
        final discard = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Bỏ thay đổi?'),
            content: const Text('Nội dung chưa lưu sẽ bị mất.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Tiếp tục sửa'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Bỏ thay đổi'),
              ),
            ],
          ),
        );
        if (discard == true && mounted) {
          setState(() => _saved = true);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.of(context).pop();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.item == null ? 'Tạo deadline' : 'Sửa deadline'),
        ),
        body: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(AppTheme.wideGap),
            children: [
              TextFormField(
                controller: _title,
                enabled: !vm.saving,
                maxLength: 120,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) => Deadline.validateTitle(value ?? ''),
              ),
              const SizedBox(height: AppTheme.gap),
              if (courses.loading) const LinearProgressIndicator(),
              if (courses.error != null) Text(courses.error!),
              DropdownButtonFormField<String>(
                key: ValueKey(_course.text),
                initialValue:
                    courses.items.any((item) => item.id == _course.text)
                    ? _course.text
                    : null,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Môn học'),
                items: courses.items
                    .map(
                      (course) => DropdownMenuItem(
                        value: course.id,
                        child: Text(
                          '${course.code} — ${course.name}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: vm.saving || courses.loading
                    ? null
                    : (value) => _course.text = value ?? '',
                validator: (value) =>
                    value == null ||
                        !courses.items.any((item) => item.id == value)
                    ? 'Chọn môn học có trong danh sách.'
                    : null,
              ),
              TextButton.icon(
                onPressed: vm.saving
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          settings: const RouteSettings(name: 'courses'),
                          builder: (_) => const CoursesScreen(),
                        ),
                      ),
                icon: const Icon(Icons.add),
                label: const Text('Thêm hoặc xem môn học'),
              ),
              const SizedBox(height: AppTheme.gap),
              OutlinedButton.icon(
                onPressed: vm.saving
                    ? null
                    : () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _due,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date == null || !context.mounted) return;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_due),
                        );
                        if (time != null && mounted) {
                          setState(
                            () => _due = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.calendar_month),
                label: Text(DateFormat('dd/MM/yyyy HH:mm').format(_due)),
              ),
              if (vm.error != null) Text(vm.error!),
              const SizedBox(height: AppTheme.gap),
              FilledButton(
                onPressed: vm.saving
                    ? null
                    : () async {
                        if (!_form.currentState!.validate()) return;
                        final success = await vm.save(
                          Deadline(
                            id: widget.item?.id ?? '',
                            title: _title.text.trim(),
                            courseId: _course.text.trim(),
                            dueAt: _due,
                            completed: widget.item?.completed ?? false,
                          ),
                        );
                        if (success && mounted) {
                          setState(() => _saved = true);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) Navigator.of(context).pop();
                          });
                        }
                      },
                child: Text(vm.saving ? 'Đang lưu…' : 'Lưu deadline'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
