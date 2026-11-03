import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_mate/services/bootstrap_service.dart';
import 'package:deadline_mate/viewmodels/bootstrap_viewmodel.dart';

class FailingBootstrap extends BootstrapService {
  int calls = 0;
  @override
  Future<void> initialize() async {
    calls++;
    throw StateError('configuration missing');
  }
}

void main() {
  test(
    'failed initialization remains recoverable and never grants access',
    () async {
      final service = FailingBootstrap();
      final vm = BootstrapViewModel(service);
      await vm.initialize();
      expect(vm.ready, isFalse);
      expect(vm.loading, isFalse);
      expect(vm.error, isNotNull);
      await vm.initialize();
      expect(service.calls, 2);
      expect(vm.ready, isFalse);
      vm.dispose();
    },
  );
}
