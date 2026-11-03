import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/deadlines_viewmodel.dart';
import '../viewmodels/study_viewmodel.dart';
import '../viewmodels/config_viewmodel.dart';
import '../widgets/status_panel.dart';
import 'courses_screen.dart';
import 'deadline_detail_screen.dart';
import 'deadline_form_screen.dart';
import 'deadlines_screen.dart';
import 'profile_screen.dart';
import 'study_screen.dart';
import 'reports_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _index == 0,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) setState(() => _index = 0);
    },
    child: Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          _Dashboard(),
          DeadlinesScreen(),
          _Calendar(),
          ReportsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Tổng quan',
          ),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Deadline'),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Lịch học',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            label: 'Báo cáo',
          ),
        ],
      ),
    ),
  );
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();
  @override
  Widget build(BuildContext context) {
    final deadlines = context.watch<DeadlinesViewModel>();
    final user = context.watch<AuthViewModel>().user;
    final config = context.watch<ConfigViewModel>().config;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deadline Mate'),
        actions: [
          IconButton(
            tooltip: 'Hồ sơ',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.wideGap),
        children: [
          Text(
            'Chào ${user?.name ?? 'bạn'}!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(config.banner),
          const SizedBox(height: AppTheme.wideGap),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.wideGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${deadlines.items.where((item) => !item.completed).length} deadline chưa xong',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '${deadlines.items.where((item) => item.completed).length} deadline đã hoàn thành',
                  ),
                ],
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const DeadlineFormScreen(),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Tạo deadline'),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CoursesScreen()),
            ),
            icon: const Icon(Icons.book_outlined),
            label: const Text('Quản lý môn học'),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const StudyScreen()),
            ),
            icon: const Icon(Icons.timer_outlined),
            label: const Text('Phiên học'),
          ),
          const SizedBox(height: AppTheme.wideGap),
          Text(
            'Deadline sắp tới',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (deadlines.loading) const LinearProgressIndicator(),
          if (deadlines.error != null) Text(deadlines.error!),
          for (final item
              in deadlines.items
                  .where((item) => !item.completed)
                  .take(config.dashboardLimit))
            Card(
              child: ListTile(
                title: Text(item.title),
                subtitle: Text(DateFormat('dd/MM HH:mm').format(item.dueAt)),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DeadlineDetailScreen(id: item.id),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar();
  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  DateTime _date = DateTime.now();
  bool _sameDay(DateTime date) =>
      date.year == _date.year &&
      date.month == _date.month &&
      date.day == _date.day;
  @override
  Widget build(BuildContext context) {
    final deadlines = context.watch<DeadlinesViewModel>();
    final sessions = context.watch<StudyViewModel>();
    final dailyDeadlines = deadlines.items
        .where((item) => _sameDay(item.dueAt))
        .toList();
    final dailySessions = sessions.items
        .where((item) => _sameDay(item.plannedAt))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch học'),
        actions: [
          IconButton(
            tooltip: 'Phiên học',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const StudyScreen()),
            ),
            icon: const Icon(Icons.timer_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.gap),
        children: [
          CalendarDatePicker(
            initialDate: _date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            onDateChanged: (value) => setState(() => _date = value),
          ),
          Text(
            DateFormat('dd/MM/yyyy').format(_date),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (deadlines.loading || sessions.loading)
            const LinearProgressIndicator(),
          if (deadlines.error != null) Text(deadlines.error!),
          if (sessions.error != null) Text(sessions.error!),
          if (dailyDeadlines.isEmpty &&
              dailySessions.isEmpty &&
              !deadlines.loading &&
              !sessions.loading)
            const StatusPanel(
              message: 'Ngày này chưa có deadline hoặc phiên học.',
            ),
          for (final item in dailyDeadlines)
            Card(
              child: ListTile(
                title: Text(item.title),
                leading: const Icon(Icons.checklist),
                subtitle: const Text('Deadline'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DeadlineDetailScreen(id: item.id),
                  ),
                ),
              ),
            ),
          for (final item in dailySessions)
            Card(
              child: ListTile(
                title: Text(item.title),
                leading: const Icon(Icons.timer_outlined),
                subtitle: Text('${item.plannedMinutes} phút'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const StudyScreen()),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
