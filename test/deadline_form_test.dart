import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:deadline_mate/screens/deadline_form_screen.dart';
import 'package:deadline_mate/viewmodels/deadlines_viewmodel.dart';
import 'package:deadline_mate/theme/app_theme.dart';

import 'deadlines_viewmodel_test.dart' show TestRepository;

void main() {
  testWidgets('failed save keeps user input; invalid form never writes', (
    tester,
  ) async {
    final repo = TestRepository()..fail = true;
    final vm = DeadlinesViewModel(repo);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const DeadlineFormScreen(),
        ),
      ),
    );
    await tester.tap(find.text('Lưu deadline'));
    await tester.pump();
    expect(find.text('Nhập tiêu đề deadline.'), findsOneWidget);
    expect(repo.creates, 0);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Bài tập Firebase',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'PRM393');
    await tester.tap(find.text('Lưu deadline'));
    await tester.pumpAndSettle();
    expect(repo.creates, 1);
    expect(find.text('Bài tập Firebase'), findsOneWidget);
    expect(find.text('Chưa lưu được thay đổi. Hãy thử lại.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    vm.dispose();
    await repo.changes.close();
  });
}
