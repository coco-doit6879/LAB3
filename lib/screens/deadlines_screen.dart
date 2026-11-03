import '../widgets/app_top_bar.dart';
import '../widgets/app_field.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/deadlines_viewmodel.dart';
import '../viewmodels/courses_viewmodel.dart';
import '../widgets/status_panel.dart';
import '../widgets/deadline_card.dart';
import 'deadline_detail_screen.dart';
import 'deadline_form_screen.dart';
import 'profile_screen.dart';

class DeadlinesScreen extends StatefulWidget {
  const DeadlinesScreen({super.key});
  @override
  State<DeadlinesScreen> createState() => _DeadlinesScreenState();
}

class _DeadlinesScreenState extends State<DeadlinesScreen> {
  late final _search = TextEditingController(
    text: context.read<DeadlinesViewModel>().searchQuery,
  );
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset(DeadlinesViewModel vm) {
    _search.clear();
    vm.resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DeadlinesViewModel>();
    final courses = context.watch<CoursesViewModel>();
    final visible = vm.visible;
    return Scaffold(
      appBar: AppTopBar(
        title: const Text('Deadline của bạn'),
        actions: [
          IconButton(
            tooltip: 'Hồ sơ',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                settings: const RouteSettings(name: 'profile'),
                builder: (_) => const ProfileScreen(),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppField(
                    controller: _search,
                    onChanged: vm.setSearch,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      labelText: 'Tìm theo tên deadline',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: AppTheme.smallGap),
                  DropdownButtonFormField<String>(
                    key: ValueKey(vm.courseFilter),
                    initialValue: vm.courseFilter ?? '',
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Môn học'),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('Tất cả môn học'),
                      ),
                      for (final course in courses.items)
                        DropdownMenuItem(
                          value: course.id,
                          child: Text(
                            '${course.code} · ${course.name}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (vm.courseFilter != null &&
                          !courses.items.any(
                            (course) => course.id == vm.courseFilter,
                          ))
                        DropdownMenuItem(
                          value: vm.courseFilter,
                          child: const Text('Môn học đã chọn không khả dụng'),
                        ),
                    ],
                    onChanged: (value) =>
                        vm.setCourseFilter(value == '' ? null : value),
                  ),
                  if (courses.error != null)
                    TextButton(
                      onPressed: courses.retry,
                      child: const Text('Thử tải lại môn học'),
                    ),
                  const SizedBox(height: AppTheme.smallGap),
                  SegmentedButton<DeadlineFilter>(
                    segments: const [
                      ButtonSegment(
                        value: DeadlineFilter.all,
                        label: Text('Tất cả'),
                      ),
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
                  if (vm.hasFilters)
                    TextButton(
                      onPressed: () => _reset(vm),
                      child: const Text('Xóa bộ lọc'),
                    ),
                  Text('${visible.length} deadline · Hạn gần nhất trước'),
                ],
              ),
            ),
          ),
          if (vm.loading || vm.error != null || visible.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: vm.loading
                  ? const StatusPanel(
                      message: 'Đang tải deadline…',
                      loading: true,
                    )
                  : vm.error != null
                  ? StatusPanel(
                      kind: StatusKind.error,
                      message: vm.error!,
                      action: 'Thử lại',
                      onAction: vm.retry,
                    )
                  : visible.isEmpty
                  ? StatusPanel(
                      message: vm.hasFilters
                          ? 'Không có deadline khớp bộ lọc.'
                          : 'Bạn chưa có deadline nào.',
                      action: vm.hasFilters ? 'Xóa bộ lọc' : 'Tạo deadline',
                      onAction: () =>
                          vm.hasFilters ? _reset(vm) : _create(context),
                    )
                  : const SizedBox.shrink(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.gap,
                0,
                AppTheme.gap,
                AppTheme.floatingActionClearance,
              ),
              sliver: SliverList.builder(
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final item = visible[index];
                  return DeadlineCard(
                    deadline: item,
                    courseLabel: courses.labelFor(item.courseId),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        settings: const RouteSettings(name: 'deadline_detail'),
                        builder: (_) => DeadlineDetailScreen(id: item.id),
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

  void _create(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      settings: const RouteSettings(name: 'deadline_form'),
      builder: (_) => const DeadlineFormScreen(),
    ),
  );
}
