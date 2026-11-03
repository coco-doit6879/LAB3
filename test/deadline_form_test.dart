import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:deadline_mate/screens/deadline_form_screen.dart';
import 'package:deadline_mate/viewmodels/deadlines_viewmodel.dart';
import 'package:deadline_mate/theme/app_theme.dart';
import 'package:deadline_mate/models/course.dart';
import 'package:deadline_mate/services/course_service.dart';
import 'package:deadline_mate/viewmodels/courses_viewmodel.dart';

import 'deadlines_viewmodel_test.dart' show TestRepository;

class TestCourses implements CourseRepository {
  @override
  Stream<List<Course>> watch() => Stream.value([
    const Course(id: 'course-1', name: 'Mobile', code: 'PRM393'),
  ]);
  @override
  Future<void> create(String name, String code) async {}
}

void main() {
  testWidgets('failed save keeps user input; invalid form never writes', (
    tester,
  ) async {
    final repo = TestRepository()..fail = true;
    final vm = DeadlinesViewModel(repo);
    final courses = CoursesViewModel(TestCourses());
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: vm),
          ChangeNotifierProvider.value(value: courses),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const DeadlineFormScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu deadline'));
    await tester.pump();
    expect(find.text('Nhập tiêu đề deadline.'), findsOneWidget);
    expect(repo.creates, 0);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Bài tập Firebase',
    );
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PRM393 — Mobile').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu deadline'));
    await tester.pumpAndSettle();
    expect(repo.creates, 1);
    expect(find.text('Bài tập Firebase'), findsOneWidget);
    expect(find.text('Chưa lưu được thay đổi. Hãy thử lại.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    vm.dispose();
    courses.dispose();
    await repo.changes.close();
  });
}
