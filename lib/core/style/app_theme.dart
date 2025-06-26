import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    fontFamily: 'noto',
    scaffoldBackgroundColor: AppColors.white,
    brightness: Brightness.light,
  );
}
