import 'package:deadline_mate/models/deadline.dart';
import 'package:deadline_mate/theme/app_theme.dart';
import 'package:deadline_mate/widgets/app_navigation.dart';
import 'package:deadline_mate/widgets/deadline_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [360.0, 412.0, 800.0]) {
    testWidgets('navigation and long deadline fit width $width', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      var selected = 0;
      var opened = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: AppNavigation(
            index: 0,
            onSelected: (value) => selected = value,
            child: Scaffold(
              body: ListView(
                children: [
                  DeadlineCard(
                    deadline: Deadline(
                      id: 'sample',
                      title: 'Hoàn thiện báo cáo và phần trình bày cho bài thực hành Flutter và Firebase',
                      courseId: 'PRM393',
                      dueAt: DateTime(2026, 11, 15, 17),
                      completed: false,
                    ),
                    onTap: () => opened = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        find.byType(NavigationRail),
        width >= 600 ? findsOneWidget : findsNothing,
      );
      expect(
        find.byType(NavigationBar),
        width < 600 ? findsOneWidget : findsNothing,
      );
      await tester.tap(find.text('Deadline'));
      expect(selected, 1);
      await tester.tap(find.byType(DeadlineCard));
      expect(opened, isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}
