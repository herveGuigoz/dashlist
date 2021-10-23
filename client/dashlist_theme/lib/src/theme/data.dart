import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_icon/path_icon.dart';

part 'data.freezed.dart';

@freezed
class AppThemeData with _$AppThemeData {
  const factory AppThemeData({
    @Default(AppThemeColorData()) AppThemeColorData colors,
    @Default(AppThemeTextStyleData()) AppThemeTextStyleData textStyles,
    @Default(AppThemeEdgeInsetsData()) AppThemeEdgeInsetsData edgeInsets,
    @Default(AppThemeBorderRadiusData()) AppThemeBorderRadiusData borderRadius,
    @Default(_FallbackAppIconThemeData()) AppIconThemeData icons,
  }) = _AppThemeData;
}

@freezed
class AppThemeColorData with _$AppThemeColorData {
  const factory AppThemeColorData({
    @Default(Color(0xFF4FD1BA)) Color accent1,
    @Default(Color(0xFF3AA995)) Color accent2,
    @Default(Color(0xFF363360)) Color foreground1,
    @Default(Color(0xFF7B76B2)) Color foreground2,
    @Default(Color(0xFFFFFFFF)) Color foregroundOpposite,
    @Default(Color(0xFFFFFFFF)) Color background1,
    @Default(Color(0xFFF9F9FF)) Color background2,
    @Default(Color(0xFFEFEFF9)) Color background3,
    @Default(Color(0xFFE96980)) Color error,
    @Default(Color(0xFFEB7330)) Color warning,
  }) = _AppThemeColorData;
}

@freezed
class AppThemeTextStyleData with _$AppThemeTextStyleData {
  const factory AppThemeTextStyleData({
    @Default(TextStyle(
      fontFamily: 'Poppins',
      fontSize: 36,
      letterSpacing: -2,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    ))
        title1,
    @Default(TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    ))
        title2,
    @Default(TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    ))
        paragraph1,
    @Default(TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    ))
        paragraph1Bold,
    @Default(TextStyle(
      fontFamily: 'Poppins',
      fontSize: 13,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    ))
        paragraph2,
    @Default(TextStyle(
      fontFamily: 'Poppins',
      fontSize: 13,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    ))
        paragraph2Bold,
    @Default(TextStyle(
      fontFamily: 'Poppins',
      fontSize: 10,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    ))
        paragraph3,
    @Default(TextStyle(
      fontFamily: 'Poppins',
      fontSize: 10,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    ))
        paragraph3Bold,
  }) = _AppThemeTextStyleData;
}

@freezed
class AppThemeEdgeInsetsData with _$AppThemeEdgeInsetsData {
  const factory AppThemeEdgeInsetsData({
    @Default(EdgeInsets.all(4)) EdgeInsets small,
    @Default(EdgeInsets.all(12)) EdgeInsets regular,
    @Default(EdgeInsets.all(24)) EdgeInsets large,
  }) = _AppThemeEdgeInsetsData;
}

@freezed
class AppThemeBorderRadiusData with _$AppThemeBorderRadiusData {
  const factory AppThemeBorderRadiusData({
    @Default(SmoothBorderRadius.all(
      SmoothRadius(cornerRadius: 4, cornerSmoothing: 1),
    ))
        SmoothBorderRadius small,
    @Default(SmoothBorderRadius.all(
      SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
    ))
        SmoothBorderRadius regular,
    @Default(SmoothBorderRadius.all(
      SmoothRadius(cornerRadius: 24, cornerSmoothing: 1),
    ))
        SmoothBorderRadius large,
  }) = _AppThemeBorderRadiusData;
}

@freezed
class AppIconData with _$AppIconData {
  const factory AppIconData({required PathIconData pathIcon}) = _AppIconData;
}

@freezed
class AppIconThemeData with _$AppIconThemeData {
  const factory AppIconThemeData({
    required AppIconData add,
  }) = _AppIconThemeData;
}

class _FallbackAppIconThemeData
    with _$AppIconThemeData
    implements AppIconThemeData {
  const _FallbackAppIconThemeData();
  @override
  AppIconData get add => _add;
  static final _add = AppIconData(
    pathIcon: PathIconData.fromData(
      'M12 2C17.5228 2 22 6.47715 22 12C22 17.5228 17.5228 22 12 22C6.47715 22 2 17.5228 2 12C2 6.47715 6.47715 2 12 2ZM12 3.5C7.30558 3.5 3.5 7.30558 3.5 12C3.5 16.6944 7.30558 20.5 12 20.5C16.6944 20.5 20.5 16.6944 20.5 12C20.5 7.30558 16.6944 3.5 12 3.5ZM12 7C12.4142 7 12.75 7.33579 12.75 7.75V11.25H16.25C16.6642 11.25 17 11.5858 17 12C17 12.4142 16.6642 12.75 16.25 12.75H12.75V16.25C12.75 16.6642 12.4142 17 12 17C11.5858 17 11.25 16.6642 11.25 16.25V12.75H7.75C7.33579 12.75 7 12.4142 7 12C7 11.5858 7.33579 11.25 7.75 11.25H11.25V7.75C11.25 7.33579 11.5858 7 12 7Z',
      viewBox: const Rect.fromLTWH(0, 0, 24, 24),
    ),
  );
}

// class FallbackAppIconThemeData with _$AppIconThemeData  {}
// https://www.twitch.tv/videos/1161496330
// 01:12:37