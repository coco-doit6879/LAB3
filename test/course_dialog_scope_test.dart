import 'package:deadline_mate/models/course.dart';
import 'package:deadline_mate/screens/courses_screen.dart';
import 'package:deadline_mate/services/course_service.dart';
import 'package:deadline_mate/theme/app_theme.dart';
import 'package:deadline_mate/viewmodels/courses_viewmodel.dart';
import 'package:deadline_mate/widgets/session_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _Courses implements CourseRepository {
  final created = <String>[];
  @override
  Stream<List<Course>> watch() => Stream.value([]);
  @override
  Future<void> create(String name, String code) async =>
      created.add('$code:$name');
}

void main() {
  testWidgets(
    'course dialog stays inside session provider and is removed with session',
    (tester) async {
      final repo = _Courses();
      final vm = CoursesViewModel(repo);
      var signedIn = true;
      late StateSetter setSession;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: StatefulBuilder(
            builder: (context, setState) {
              setSession = setState;
              return signedIn
                  ? ChangeNotifierProvider.value(
                      value: vm,
                      child: const SessionNavigator(home: CoursesScreen()),
                    )
                  : const Scaffold(body: Text('Signed out'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thêm môn học'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Môn học'), findsOneWidget);
      await tester.tap(find.text('Thêm môn học'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Mobile');
      await tester.enterText(find.byType(TextFormField).at(1), 'PRM393');
      await tester.tap(find.widgetWithText(FilledButton, 'Thêm môn học'));
      await tester.pumpAndSettle();
      expect(repo.created, ['PRM393:Mobile']);
      expect(find.byType(AlertDialog), findsNothing);
      await tester.tap(find.text('Thêm môn học'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      setSession(() => signedIn = false);
      await tester.pumpAndSettle();
      expect(find.text('Signed out'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      vm.dispose();
    },
  );
}
