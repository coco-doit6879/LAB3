import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract interface class Telemetry {
  Future<void> event(String name, [Map<String, Object> parameters]);
  Future<void> screen(String name);
  Future<void> handled(String operation);
}

class NoTelemetry implements Telemetry {
  const NoTelemetry();
  @override
  Future<void> event(
    String name, [
    Map<String, Object> parameters = const {},
  ]) async {}
  @override
  Future<void> screen(String name) async {}
  @override
  Future<void> handled(String operation) async {}
}

class FirebaseTelemetry implements Telemetry {
  @override
  Future<void> event(
    String name, [
    Map<String, Object> parameters = const {},
  ]) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (_) {
      /* Telemetry must not turn a successful data operation into failure. */
    }
  }

  @override
  Future<void> screen(String name) async {
    try {
      await FirebaseAnalytics.instance.logScreenView(screenName: name);
    } catch (_) {
      /* Screen rendering remains available offline. */
    }
  }

  @override
  Future<void> handled(String operation) async {
    try {
      await FirebaseCrashlytics.instance.setCustomKey('operation', operation);
      // Do not upload exception text: it can contain private data or tokens.
      await FirebaseCrashlytics.instance.recordError(
        StateError('Operation failed: $operation'),
        StackTrace.current,
        fatal: false,
      );
    } catch (_) {
      /* Diagnostics cannot block recovery UI. */
    }
  }

  static Future<void> identify(String? uid) async {
    try {
      await FirebaseAnalytics.instance.setUserId(id: uid);
      await FirebaseCrashlytics.instance.setUserIdentifier(uid ?? '');
      await FirebaseCrashlytics.instance.setCustomKey(
        'app_topic',
        'deadline_mate',
      );
    } catch (_) {
      /* Session authorization does not depend on telemetry. */
    }
  }

  static void installErrorHandlers() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static void testCrash() {
    if (kDebugMode) FirebaseCrashlytics.instance.crash();
  }
}

class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this.telemetry);
  final Telemetry telemetry;
  void _record(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (route is PageRoute && name != null) telemetry.screen(name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _record(route);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _record(previousRoute);
}
