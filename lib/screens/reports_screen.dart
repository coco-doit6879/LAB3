import '../widgets/app_top_bar.dart';
import '../widgets/app_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/config_viewmodel.dart';
import '../viewmodels/deadlines_viewmodel.dart';
import '../viewmodels/courses_viewmodel.dart';
import '../viewmodels/reports_viewmodel.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportsViewModel>();
    final deadlines = context.watch<DeadlinesViewModel>();
    final courses = context.watch<CoursesViewModel>();
    final config = context.watch<ConfigViewModel>().config;
    return Scaffold(
      appBar: AppTopBar(title: const Text('Báo cáo')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.wideGap),
        children: [
          Text(
            'Nhìn lại tiến độ',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'Phạm vi: bộ lọc deadline đang chọn · ${deadlines.visible.length} mục',
          ),
          const SizedBox(height: AppTheme.gap),
          if (courses.loading) const Text('Đang tải tên môn học cho báo cáo…'),
          if (courses.error != null)
            TextButton(
              onPressed: courses.retry,
              child: const Text('Thử tải lại môn học để xuất báo cáo'),
            ),
          if (!config.enableExport)
            const Text('Xuất PDF đang tắt theo cấu hình từ xa.'),
          AppButton.icon(
            loading: vm.busy,
            onPressed:
                vm.busy ||
                    courses.loading ||
                    courses.error != null ||
                    deadlines.loading ||
                    deadlines.error != null ||
                    !config.enableExport
                ? null
                : () => vm.export(
                    deadlines.visible,
                    enabled: config.enableExport,
                    courseLabels: courses.labels,
                  ),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(vm.busy ? 'Đang xuất và tải lên…' : 'Xuất báo cáo PDF'),
          ),
          if (vm.busy)
            LinearProgressIndicator(
              value: vm.progress > 0 ? vm.progress : null,
            ),
          if (vm.error != null) Text(vm.error!),
          if (vm.success != null) Text(vm.success!),
          const SizedBox(height: AppTheme.wideGap),
          Text(
            'Lịch sử báo cáo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (vm.loading) const LinearProgressIndicator(),
          if (!vm.loading && vm.items.isEmpty)
            const Text('Chưa có báo cáo được tải lên.'),
          TextButton(onPressed: vm.retry, child: const Text('Tải lại lịch sử')),
          for (final report in vm.items)
            Card(
              child: ListTile(
                title: Text(report.fileName),
                subtitle: Text('${report.itemCount} deadline'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => vm.open(report),
              ),
            ),
        ],
      ),
    );
  }
}
