import 'package:flutter/material.dart';

abstract class Go {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static BuildContext? get context => _navigatorKey.currentContext;

  static Future<T?> to<T extends Object?>(Widget page) async {
    return navigatorKey.currentState?.push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<T?> toReplace<T extends Object?, TO extends Object?>(Widget page) async {
    return navigatorKey.currentState?.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<void> back<T extends Object?>([T? result]) async {
    return navigatorKey.currentState?.pop(result);
  }
}

abstract class GoMessenger {
  static Future<T?> dialog<T>(Widget content) async {
    final ctx = Go.context;
    if (ctx == null) return null;
    return showDialog<T>(context: ctx, builder: (context) => content);
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? snackBar(SnackBar snackBar) {
    final ctx = Go.context;
    if (ctx == null) return null;
    return ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  }
}