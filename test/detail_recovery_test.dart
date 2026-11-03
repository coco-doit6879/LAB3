import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:deadline_mate/screens/deadline_detail_screen.dart';
import 'package:deadline_mate/viewmodels/deadlines_viewmodel.dart';

import 'deadlines_viewmodel_test.dart' show TestRepository;

void main() {
  testWidgets(
    'failed detail load offers retry instead of claiming record was deleted',
    (tester) async {
      final repo = TestRepository();
      final vm = DeadlinesViewModel(repo);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const MaterialApp(home: DeadlineDetailScreen(id: 'existing')),
        ),
      );
      repo.changes.addError(StateError('permission denied'));
      await tester.pump();
      expect(find.text('Deadline không còn tồn tại.'), findsNothing);
      expect(find.text('Thử lại'), findsOneWidget);
      await tester.tap(find.text('Thử lại'));
      await tester.pump();
      expect(vm.loading, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      vm.dispose();
      await repo.changes.close();
    },
  );
}
