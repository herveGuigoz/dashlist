import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class NoTransitionPage<T> extends CustomTransitionPage<T> {
  NoTransitionPage({
    LocalKey? key,
    required Widget child,
  }) : super(key: key, child: child, transitionsBuilder: (_, __, ___, c) => c);
}
