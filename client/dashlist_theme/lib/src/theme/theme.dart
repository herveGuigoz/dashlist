import 'package:dashlist_theme/src/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data.dart';

class AppTheme extends InheritedWidget {
  const AppTheme({
    Key? key,
    required this.appThemeData,
    required Widget child,
  }) : super(key: key, child: child);

  final DashlistThemeData appThemeData;

  static DashlistThemeData of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    assert(result != null, 'No AppTheme found in context');
    return result!.appThemeData;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return oldWidget.appThemeData != appThemeData;
  }
}

class AppThemeData {
  static const primaryColor = DashlistColors.blue8;
  static const double appBarHeight = 100;
  static const double buttonHeight = 55;

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: toMaterialColor(primaryColor),
    scaffoldBackgroundColor: DashlistColors.gray12,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme,
    textButtonTheme: _textButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
  );

  static final _textTheme = GoogleFonts.poppinsTextTheme();

  static final _appBarTheme = AppBarTheme(
    titleTextStyle: _textTheme.headline5,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: DashlistColors.gray12,
    elevation: 0,
    toolbarTextStyle: _textTheme.headline5,
    iconTheme: const IconThemeData(color: DashlistColors.gray1),
  );

  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(primary: DashlistColors.gray1),
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: DashlistColors.gray1,
      minimumSize: const Size(double.infinity, buttonHeight),
      side: const BorderSide(color: DashlistColors.gray1),
    ),
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primaryColor,
      minimumSize: const Size(double.infinity, buttonHeight),
    ),
  );

  static const _floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: DashlistColors.gray12,
    foregroundColor: primaryColor,
  );
}

MaterialColor toMaterialColor(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  final red = color.red, green = color.green, blue = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      red + ((ds < 0 ? red : (255 - red)) * ds).round(),
      green + ((ds < 0 ? green : (255 - green)) * ds).round(),
      blue + ((ds < 0 ? blue : (255 - blue)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}