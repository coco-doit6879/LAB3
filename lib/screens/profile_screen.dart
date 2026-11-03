import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/config_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final user = auth.user;
    final remote = context.watch<ConfigViewModel>();
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
