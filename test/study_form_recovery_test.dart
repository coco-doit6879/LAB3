import 'package:deadline_mate/screens/study_screen.dart';
import 'package:deadline_mate/theme/app_theme.dart';
import 'package:deadline_mate/viewmodels/study_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'study_viewmodel_test.dart' show FakeStudyRepository;

void main() {
  testWidgets('study form preserves input and draft ID across failed retries', (
    tester,
  ) async {
    final repository = FakeStudyRepository()..fail = true;
    final vm = StudyViewModel(repository);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: MaterialApp(theme: AppTheme.light, home: const StudyScreen()),
      ),
    );
    repository.controller.add([]);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lập phiên học'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Ôn retry LAB3');
    for (var attempt = 0; attempt < 2; attempt++) {
      await tester.ensureVisible(find.text('Lưu phiên học'));
      await tester.tap(find.text('Lưu phiên học'));
      await tester.pumpAndSettle();
      expect(find.text('Ôn retry LAB3'), findsOneWidget);
      expect(
        find.text(
          'Chưa lưu được phiên học. Kiểm tra mạng và tải lại trạng thái.',
        ),
        findsOneWidget,
      );
    }
    expect(repository.submittedIds, ['study-draft-1', 'study-draft-1']);
    repository.fail = false;
    await tester.ensureVisible(find.text('Lưu phiên học'));
    await tester.tap(find.text('Lưu phiên học'));
    await tester.pumpAndSettle();
    expect(repository.submittedIds, [
      'study-draft-1',
      'study-draft-1',
      'study-draft-1',
    ]);
    expect(find.text('Lưu phiên học'), findsNothing);
    // A distinct form must allocate a distinct ID even for the same title.
    await tester.tap(find.text('Lập phiên học'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Ôn retry LAB3');
    await tester.ensureVisible(find.text('Lưu phiên học'));
    await tester.tap(find.text('Lưu phiên học'));
    await tester.pumpAndSettle();
    expect(repository.submittedIds.last, 'study-draft-2');
    await tester.pumpWidget(const SizedBox());
    vm.dispose();
    await repository.controller.close();
  });
}
