import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_mate/models/deadline.dart';
import 'package:deadline_mate/models/report.dart';
import 'package:deadline_mate/services/config_service.dart';
import 'package:deadline_mate/services/report_service.dart';
import 'package:deadline_mate/viewmodels/config_viewmodel.dart';
import 'package:deadline_mate/viewmodels/reports_viewmodel.dart';

class FakeConfig implements ConfigRepository {
  bool fail = false;
  @override
  Future<AppConfig> fetch() async {
    if (fail) throw StateError('offline');
    return const AppConfig(dashboardLimit: 2, enableExport: false);
  }
}

class FakeReports implements ReportRepository {
  int exports = 0;
  bool fail = false;
  @override
  Stream<List<Report>> watch() => const Stream.empty();
  @override
  Future<void> open(String url) async {}
  @override
  Future<void> export(
    List<Deadline> items,
    void Function(double) onProgress,
  ) async {
    exports++;
    onProgress(0.5);
    if (fail) throw StateError('upload failed');
  }
}

void main() {
  test('config failure keeps defaults or last successful settings', () async {
    final repo = FakeConfig()..fail = true;
    final vm = ConfigViewModel(repo);
    await vm.refresh();
    expect(vm.config.dashboardLimit, 5);
    expect(vm.config.enableExport, isTrue);
    repo.fail = false;
    await vm.refresh();
    expect(vm.config.dashboardLimit, 2);
    expect(vm.config.enableExport, isFalse);
    repo.fail = true;
    await vm.refresh();
    expect(vm.config.enableExport, isFalse);
    expect(vm.error, isNotNull);
    vm.dispose();
  });
  test(
    'disabled exports never call storage; upload failure never claims success',
    () async {
      final repo = FakeReports();
      final vm = ReportsViewModel(repo);
      await vm.export([], enabled: false);
      expect(repo.exports, 0);
      repo.fail = true;
      await vm.export([], enabled: true);
      expect(vm.success, isNull);
      expect(vm.error, isNotNull);
      expect(vm.busy, isFalse);
      repo.fail = false;
      await vm.export([], enabled: true);
      expect(vm.success, isNotNull);
      expect(vm.error, isNull);
      vm.dispose();
    },
  );
}
