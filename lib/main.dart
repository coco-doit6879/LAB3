import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'screens/setup_screen.dart';
import 'services/bootstrap_service.dart';
import 'theme/app_theme.dart';
import 'viewmodels/bootstrap_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeadlineMateApp());
}

class DeadlineMateApp extends StatelessWidget {
  const DeadlineMateApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Deadline Mate',
    locale: const Locale('vi'),
    supportedLocales: const [Locale('vi')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: AppTheme.light,
    home: ChangeNotifierProvider(
      create: (_) => BootstrapViewModel(BootstrapService())..initialize(),
      child: const SetupScreen(),
    ),
  );
}
