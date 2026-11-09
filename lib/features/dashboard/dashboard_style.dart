import 'package:flutter/material.dart';

import '../../gen/fonts.gen.dart';
import '../../ui_kit/forma_theme.dart';

abstract final class DashboardStyle {
  static TextStyle get body => TextStyle(
    fontFamily: FontFamily.iBMPlexSans,
    color: FormaColors.text,
    fontSize: 14,
    height: 1.25,
  );
  static TextStyle get muted => TextStyle(
    fontFamily: FontFamily.iBMPlexSans,
    color: FormaColors.muted,
    fontSize: 12,
    height: 1.25,
  );
  static TextStyle get small => TextStyle(
    fontFamily: FontFamily.iBMPlexSans,
    color: FormaColors.muted,
    fontSize: 10,
    height: 1.2,
  );
  static TextStyle get title => TextStyle(
    fontFamily: FontFamily.unbounded,
    color: FormaColors.text,
    fontSize: 23,
    fontWeight: FontWeight.w600,
    height: 1.12,
    letterSpacing: -1,
  );
  static TextStyle get metric => TextStyle(
    fontFamily: FontFamily.unbounded,
    color: FormaColors.text,
    fontSize: 43,
    fontWeight: FontWeight.w500,
    height: 1.08,
    letterSpacing: -2,
  );
}
