import 'package:flutter/material.dart';

/// Owns authenticated routes and forwards Android Back into their Navigator.
class SessionNavigator extends StatefulWidget {
  const SessionNavigator({
    super.key,
    required this.home,
    this.observers = const [],
  });
  final Widget home;
  final List<NavigatorObserver> observers;
  @override
  State<SessionNavigator> createState() => _SessionNavigatorState();
}

class _SessionNavigatorState extends State<SessionNavigator> {
  final _navigator = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) => NavigatorPopHandler<Object?>(
    onPopWithResult: (result) {
      // maybePop respects dirty-form and HomeShell PopScopes as well as dialogs.
      _navigator.currentState?.maybePop(result);
    },
    child: Navigator(
      key: _navigator,
      observers: widget.observers,
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        settings: const RouteSettings(name: 'dashboard'),
        builder: (_) => widget.home,
      ),
    ),
  );
}
