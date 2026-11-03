import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/config_viewmodel.dart';
import '../viewmodels/diagnostics_viewmodel.dart';
import '../viewmodels/notifications_viewmodel.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final user = auth.user;
    final remote = context.watch<ConfigViewModel>();
    final diagnostics = context.watch<DiagnosticsViewModel>();
    final notifications = context.watch<NotificationsViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.wideGap),
        children: [
          if (user?.photoUrl != null)
            Center(
              child: CircleAvatar(
                radius: AppTheme.heroIcon,
                child: ClipOval(
                  child: Image.network(
                    user!.photoUrl!,
                    errorBuilder: (_, error, stack) => const Icon(Icons.person),
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppTheme.gap),
          Text(
            user?.name ?? 'Sinh viên',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(user?.email ?? ''),
          const SizedBox(height: AppTheme.wideGap),
          Text('Cấu hình từ xa', style: Theme.of(context).textTheme.titleLarge),
          Text('dashboard_item_limit: ${remote.config.dashboardLimit}'),
          Text('enable_pdf_export: ${remote.config.enableExport}'),
          Text('study_banner: ${remote.config.banner}'),
          const Text(
            'Chu kỳ tải tối thiểu: 1 phút. Thay đổi cần được Publish trên Console.',
          ),
          if (remote.error != null) Text(remote.error!),
          OutlinedButton(
            onPressed: remote.busy ? null : remote.refresh,
            child: Text(remote.busy ? 'Đang tải…' : 'Tải cấu hình mới'),
          ),
          if (auth.error != null) Text(auth.error!),
          const SizedBox(height: AppTheme.wideGap),
          Text('Thông báo', style: Theme.of(context).textTheme.titleLarge),
          Text('Quyền: ${notifications.permission}'),
          if (notifications.error != null) Text(notifications.error!),
          OutlinedButton(
            onPressed: notifications.busy
                ? null
                : notifications.requestPermission,
            child: const Text('Xin quyền và lấy token FCM'),
          ),
          if (notifications.deviceToken != null)
            SelectableText(notifications.deviceToken!),
          const Text(
            'Token dành cho thông báo thử trên Console; không đưa token vào báo cáo công khai.',
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                settings: const RouteSettings(name: 'notifications'),
                builder: (_) => const NotificationsScreen(),
              ),
            ),
            child: const Text('Trung tâm thông báo'),
          ),
          const SizedBox(height: AppTheme.wideGap),
          Text(
            'Khu vực trình diễn',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (diagnostics.message != null) Text(diagnostics.message!),
          OutlinedButton(
            onPressed: diagnostics.busy ? null : diagnostics.handledDemo,
            child: const Text('Ghi lỗi đã xử lý'),
          ),
          if (diagnostics.canCrash)
            TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Thử crash ứng dụng?'),
                    content: const Text(
                      'Ứng dụng sẽ đóng. Chỉ dùng khi trình diễn Crashlytics.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Hủy'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Thử crash'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) diagnostics.crashDemo();
              },
              child: const Text('Tạo test crash (debug)'),
            ),
          FilledButton.icon(
            onPressed: auth.busy ? null : auth.signOut,
            icon: const Icon(Icons.logout),
            label: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
