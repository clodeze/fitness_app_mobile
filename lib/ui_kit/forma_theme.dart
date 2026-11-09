import 'package:flutter/material.dart';

import '../gen/fonts.gen.dart';

/// Design tokens from the FORMA UI kit.
abstract final class FormaColors {
  static bool light = false;
  static Color get background =>
      light ? const Color(0xFFF2F1EC) : const Color(0xFF0D0D0E);
  static Color get surface =>
      light ? const Color(0xFFFFFFFF) : const Color(0xFF171719);
  static Color get raised =>
      light ? const Color(0xFFE8E7E1) : const Color(0xFF232325);
  static Color get line =>
      light ? const Color(0xFFE0DFD8) : const Color(0xFF2D2D30);
  static Color get text =>
      light ? const Color(0xFF111113) : const Color(0xFFF3F1E9);
  static Color get muted =>
      light ? const Color(0xFF6B6B66) : const Color(0xFF92918D);
  static const accent = Color(0xFFC5FF28);
  static const accentAlt = Color(0xFFE46432);
  static Color get ink =>
      light ? const Color(0xFF17171A) : const Color(0xFF0D0D0E);
  static Color get focusedLine =>
      light ? const Color(0xFFA8C93C) : const Color(0xFF5B701C);
  static Color get buttonBackground => light ? ink : accent;
  static Color get buttonForeground => light ? accent : ink;
  static Color get buttonIconBackground => light ? accent : ink;
  static Color get buttonIconForeground => light ? ink : accent;
}

abstract final class FormaSpace {
  static const step = 8.0;
  static const screen = 24.0;
  static const fieldRadius = 14.0;
  static const goalRadius = 20.0;
  static const cardRadius = 22.0;
  static const pillRadius = 100.0;
}

abstract final class FormaType {
  static TextStyle get number => TextStyle(
    fontFamily: FontFamily.unbounded,
    fontSize: 44,
    fontWeight: FontWeight.w500,
    letterSpacing: -2,
    height: 1.12,
    color: FormaColors.text,
  );

  static TextStyle get heading => TextStyle(
    fontFamily: FontFamily.unbounded,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
    height: 1.08,
    color: FormaColors.text,
  );

  static TextStyle get body => TextStyle(
    fontFamily: FontFamily.onest,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: FormaColors.text,
  );

  static TextStyle get button => TextStyle(
    fontFamily: FontFamily.onest,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: FormaColors.text,
  );

  static TextStyle get metric => TextStyle(
    fontFamily: FontFamily.onest,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: FormaColors.text,
  );

  static TextStyle get caption => TextStyle(
    fontFamily: FontFamily.onest,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: FormaColors.muted,
  );

  static TextStyle get overline => TextStyle(
    fontFamily: FontFamily.onest,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    height: 1.4,
    color: FormaColors.muted,
  );

  static TextStyle get section => TextStyle(
    fontFamily: FontFamily.onest,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: FormaColors.muted,
  );
}

abstract final class FormaTheme {
  static ThemeData get data => ThemeData(
    useMaterial3: true,
    brightness: FormaColors.light ? Brightness.light : Brightness.dark,
    scaffoldBackgroundColor: FormaColors.background,
    fontFamily: FontFamily.onest,
    colorScheme: ColorScheme.fromSeed(
      seedColor: FormaColors.accent,
      brightness: FormaColors.light ? Brightness.light : Brightness.dark,
      primary: FormaColors.accent,
      secondary: FormaColors.accentAlt,
      surface: FormaColors.surface,
      onSurface: FormaColors.text,
    ),
    textTheme: TextTheme(
      displayLarge: FormaType.number,
      headlineMedium: FormaType.heading,
      bodyMedium: FormaType.body,
      labelLarge: FormaType.button,
      labelSmall: FormaType.caption,
    ),
  );
}
