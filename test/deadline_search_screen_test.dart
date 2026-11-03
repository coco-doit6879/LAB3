import 'package:deadline_mate/models/course.dart';
import 'package:deadline_mate/models/deadline.dart';
import 'package:deadline_mate/screens/deadlines_screen.dart';
import 'package:deadline_mate/services/course_service.dart';
import 'package:deadline_mate/theme/app_theme.dart';
import 'package:deadline_mate/viewmodels/courses_viewmodel.dart';
import 'package:deadline_mate/viewmodels/deadlines_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'deadlines_viewmodel_test.dart' show TestRepository;

class _Courses implements CourseRepository {
  @override
  Stream<List<Course>> watch() => Stream.value([
    const Course(id: 'PRM393', name: 'Flutter và Firebase', code: 'PRM393'),
  ]);
  @override
  Future<void> create(String name, String code) async {}
}

void main() {
  testWidgets('search empty state can recover at phone width with keyboard', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final repo = TestRepository();
    final deadlines = DeadlinesViewModel(repo);
    final courses = CoursesViewModel(_Courses());
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: deadlines),
          ChangeNotifierProvider.value(value: courses),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const DeadlinesScreen(),
        ),
      ),
    );
    repo.changes.add([
      Deadline(
        id: 'a',
        title: 'Nộp LAB 3',
        courseId: 'PRM393',
        dueAt: DateTime(2026, 11, 15),
      ),
    ]);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Không khớp');
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    expect(deadlines.visible, isEmpty);
    expect(tester.takeException(), isNull);
    // The reset beside the controls remains reachable even if the keyboard
    // leaves only a small viewport for the empty-state panel.
    final reset = find.text('Xóa bộ lọc').first;
    await tester.ensureVisible(reset);
    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(deadlines.visible.single.id, 'a');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    deadlines.dispose();
    courses.dispose();
    await repo.changes.close();
  });
}
