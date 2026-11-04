import 'package:deadline_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calendar uses Vietnamese even on an English device', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('en', 'US');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    final app = const DeadlineMateApp().build(
      tester.element(find.byType(SizedBox)),
    ) as MaterialApp;
    // Exercise the production localization configuration without starting Firebase.
    await tester.pumpWidget(
      MaterialApp(
        locale: app.locale,
        supportedLocales: app.supportedLocales,
        localizationsDelegates: app.localizationsDelegates,
        home: Scaffold(
          body: CalendarDatePicker(
            initialDate: DateTime(2026, 11, 4),
            firstDate: DateTime(2026),
            lastDate: DateTime(2027),
            onDateChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(CalendarDatePicker));
    expect(Localizations.localeOf(context).languageCode, 'vi');
    expect(MaterialLocalizations.of(context).cancelButtonLabel, 'Huỷ');
    expect(find.textContaining('tháng 11'), findsWidgets);
  });
}
