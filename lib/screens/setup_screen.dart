import '../widgets/app_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodels/bootstrap_viewmodel.dart';
import 'auth_gate.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BootstrapViewModel>();
    if (vm.ready) return const AuthGate();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.wideGap),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppTheme.maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school_outlined, size: AppTheme.heroIcon),
                  const SizedBox(height: AppTheme.wideGap),
                  Text(
                    'Deadline Mate',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppTheme.gap),
                  const Text(
                    'Bớt lo deadline. Tập trung từng phiên học.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.wideGap),
                  if (vm.loading)
                    const Center(child: CircularProgressIndicator()),
                  if (vm.error != null)
                    Text(vm.error!, textAlign: TextAlign.center),
                  if (!vm.loading && !vm.ready)
                    AppButton.icon(
                      onPressed: vm.initialize,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử kết nối lại'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
