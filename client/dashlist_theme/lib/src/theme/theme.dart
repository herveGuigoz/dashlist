import 'package:flutter/material.dart';

import 'data.dart';

class AppTheme extends InheritedWidget {
  const AppTheme({
    Key? key,
    required this.appThemeData,
    required Widget child,
  }) : super(key: key, child: child);

  final AppThemeData appThemeData;

  static AppThemeData of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    assert(result != null, 'No AppTheme found in context');
    return result!.appThemeData;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return oldWidget.appThemeData != appThemeData;
  }
}
