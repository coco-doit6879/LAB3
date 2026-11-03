import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/firestore_deadline_service.dart';
import '../services/course_service.dart';
import '../services/study_service.dart';
import '../services/config_service.dart';
import '../services/report_service.dart';
import '../services/telemetry_service.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/deadlines_viewmodel.dart';
import '../viewmodels/courses_viewmodel.dart';
import '../viewmodels/study_viewmodel.dart';
import '../viewmodels/config_viewmodel.dart';
import '../viewmodels/reports_viewmodel.dart';
import '../viewmodels/diagnostics_viewmodel.dart';
import '../viewmodels/notifications_viewmodel.dart';
import 'home_shell.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => AuthViewModel(GoogleAuthService()),
    child: const _SessionGate(),
  );
}

class _SessionGate extends StatelessWidget {
  const _SessionGate();
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    if (auth.initializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (auth.user == null) return const LoginScreen();
    // Destroy the entire inner route stack and user-scoped state on sign out.
    return MultiProvider(
      key: ValueKey(auth.user!.uid),
      providers: [
        Provider<Telemetry>(create: (_) => FirebaseTelemetry()),
        ChangeNotifierProvider(create: (_) => DiagnosticsViewModel()),
        ChangeNotifierProvider(
          create: (_) => NotificationsViewModel(
            FirebaseNotificationService(auth.user!.uid),
          ),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ConfigViewModel(RemoteConfigService())..refresh(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportsViewModel(
            FirebaseReportService(auth.user!.uid),
            telemetry: FirebaseTelemetry(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DeadlinesViewModel(
            FirestoreDeadlineService(uid: auth.user!.uid),
            telemetry: FirebaseTelemetry(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              CoursesViewModel(FirestoreCourseService(auth.user!.uid)),
        ),
        ChangeNotifierProvider(
          create: (_) => StudyViewModel(
            FirestoreStudyService(auth.user!.uid),
            telemetry: FirebaseTelemetry(),
          ),
        ),
      ],
      child: Navigator(
        observers: [AnalyticsRouteObserver(FirebaseTelemetry())],
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: const RouteSettings(name: 'dashboard'),
          builder: (_) => const HomeShell(),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.wideGap),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppTheme.maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  FilledButton.icon(
                    onPressed: auth.busy ? null : auth.signIn,
                    icon: const Icon(Icons.login),
                    label: Text(
                      auth.busy ? 'Đang đăng nhập…' : 'Tiếp tục với Google',
                    ),
                  ),
                  if (auth.error != null)
                    Text(auth.error!, semanticsLabel: auth.error),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
