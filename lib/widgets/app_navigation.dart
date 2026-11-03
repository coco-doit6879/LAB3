import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// One destination model keeps phone navigation and the wide layout in sync.
class AppNavigation extends StatelessWidget {
  const AppNavigation({
    super.key,
    required this.index,
    required this.onSelected,
    required this.child,
  });

  final int index;
  final ValueChanged<int> onSelected;
  final Widget child;
  static const _destinations = [
    (Icons.dashboard_outlined, 'Tổng quan'),
    (Icons.checklist, 'Deadline'),
    (Icons.calendar_month_outlined, 'Lịch học'),
    (Icons.assessment_outlined, 'Báo cáo'),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 600;
      return Scaffold(
        body: Row(
          children: [
            if (wide)
              SafeArea(
                child: NavigationRail(
                  selectedIndex: index,
                  onDestinationSelected: onSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final destination in _destinations)
                      NavigationRailDestination(
                        icon: Icon(destination.$1),
                        label: Text(destination.$2),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppTheme.maxWidth,
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: wide
            ? null
            : NavigationBar(
                selectedIndex: index,
                onDestinationSelected: onSelected,
                destinations: [
                  for (final destination in _destinations)
                    NavigationDestination(
                      icon: Icon(destination.$1),
                      label: destination.$2,
                    ),
                ],
              ),
      );
    },
  );
}
