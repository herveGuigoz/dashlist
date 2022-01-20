import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_icon/path_icon.dart';

part 'data.freezed.dart';

@freezed
class DashlistThemeData with _$DashlistThemeData {
  const factory DashlistThemeData({
    @Default(DashlistColorData()) DashlistColorData colors,
    @Default(DashlistTextStyleData()) DashlistTextStyleData textStyles,
    @Default(DashlistEdgeInsetsData()) DashlistEdgeInsetsData edgeInsets,
    @Default(DashlistRadiusData()) DashlistRadiusData borderRadius,
    @Default(_FallbackIconThemeData()) DashlistIconThemeData icons,
  }) = _DashlistThemeData;
}

@freezed
class DashlistColorData with _$DashlistColorData {
  const factory DashlistColorData({
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
  }) = _DashlistColorData;
}

@freezed
class DashlistTextStyleData with _$DashlistTextStyleData {
  const factory DashlistTextStyleData({
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
  }) = _DashlistTextStyleData;
}

@freezed
class DashlistEdgeInsetsData with _$DashlistEdgeInsetsData {
  const factory DashlistEdgeInsetsData({
    @Default(EdgeInsets.all(4)) EdgeInsets small,
    @Default(EdgeInsets.all(12)) EdgeInsets regular,
    @Default(EdgeInsets.all(24)) EdgeInsets large,
  }) = _DashlistEdgeInsetsData;
}

@freezed
class DashlistRadiusData with _$DashlistRadiusData {
  const factory DashlistRadiusData({
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
  }) = _DashlistRadiusData;
}

@freezed
class DashlistIconData with _$DashlistIconData {
  const factory DashlistIconData({
    required PathIconData pathIcon,
  }) = _DashlistIconData;
}

@freezed
class DashlistIconThemeData with _$DashlistIconThemeData {
  const factory DashlistIconThemeData({
    required DashlistIconData add,
  }) = _DashlistIconThemeData;
}

class _FallbackIconThemeData
    with _$DashlistIconThemeData
    implements DashlistIconThemeData {
  const _FallbackIconThemeData();

  @override
  DashlistIconData get add => _add;

  static final _add = DashlistIconData(
    pathIcon: PathIconData.fromData(
      'M12 2C17.5228 2 22 6.47715 22 12C22 17.5228 17.5228 22 12 22C6.47715 22 2 17.5228 2 12C2 6.47715 6.47715 2 12 2ZM12 3.5C7.30558 3.5 3.5 7.30558 3.5 12C3.5 16.6944 7.30558 20.5 12 20.5C16.6944 20.5 20.5 16.6944 20.5 12C20.5 7.30558 16.6944 3.5 12 3.5ZM12 7C12.4142 7 12.75 7.33579 12.75 7.75V11.25H16.25C16.6642 11.25 17 11.5858 17 12C17 12.4142 16.6642 12.75 16.25 12.75H12.75V16.25C12.75 16.6642 12.4142 17 12 17C11.5858 17 11.25 16.6642 11.25 16.25V12.75H7.75C7.33579 12.75 7 12.4142 7 12C7 11.5858 7.33579 11.25 7.75 11.25H11.25V7.75C11.25 7.33579 11.5858 7 12 7Z',
      viewBox: const Rect.fromLTWH(0, 0, 24, 24),
    ),
  );
}
