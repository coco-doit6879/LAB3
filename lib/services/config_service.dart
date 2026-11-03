import 'package:firebase_remote_config/firebase_remote_config.dart';

class AppConfig {
  const AppConfig({
    this.dashboardLimit = 5,
    this.enableExport = true,
    this.banner = 'Một việc mỗi lúc. Một bước gần mục tiêu hơn.',
  });
  final int dashboardLimit;
  final bool enableExport;
  final String banner;
}

abstract interface class ConfigRepository {
  Future<AppConfig> fetch();
}

class RemoteConfigService implements ConfigRepository {
  @override
  Future<AppConfig> fetch() async {
    final config = FirebaseRemoteConfig.instance;
    await config.setDefaults({
      'dashboard_item_limit': 5,
      'enable_pdf_export': true,
      'study_banner': const AppConfig().banner,
    });
    await config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );
    await config.fetchAndActivate();
    return AppConfig(
      dashboardLimit: config.getInt('dashboard_item_limit').clamp(1, 50),
      enableExport: config.getBool('enable_pdf_export'),
      banner: config.getString('study_banner'),
    );
  }
}
