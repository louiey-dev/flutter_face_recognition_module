import 'package:face_recognition_module/common/common.dart';
import 'package:face_recognition_module/common/theme/color/dark_app_colors.dart';
import 'package:face_recognition_module/common/theme/color/light_app_colors.dart';
import 'package:face_recognition_module/common/theme/shadows/dart_app_shadows.dart';
import 'package:face_recognition_module/common/theme/shadows/light_app_shadows.dart';
import 'package:flutter/material.dart';

enum CustomTheme {
  dark,
  light;

  static MaterialColor primarySwatchColor = Colors.lightBlue;

  AbstractThemeColors get appColors {
    switch (this) {
      case CustomTheme.dark:
        return DarkAppColors();
      case CustomTheme.light:
        return LightAppColors();
    }
  }

  AbsThemeShadows get appShadows {
    switch (this) {
      case CustomTheme.dark:
        return DarkAppShadows();
      case CustomTheme.light:
        return LightAppShadows();
    }
  }

  ThemeData get themeData {
    switch (this) {
      case CustomTheme.dark:
        return darkTheme;
      case CustomTheme.light:
        return lightTheme;
    }
  }

  static ThemeData lightTheme = ThemeData(
      primarySwatch: primarySwatchColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      // textTheme: GoogleFonts.singleDayTextTheme(
      //   ThemeData(brightness: Brightness.light).textTheme,
      // ),
      colorScheme: const ColorScheme.light(background: Colors.white));

  static ThemeData darkTheme = ThemeData(
      primarySwatch: primarySwatchColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      // textTheme: GoogleFonts.nanumMyeongjoTextTheme(
      //   ThemeData(brightness: Brightness.dark).textTheme,
      // ),
      colorScheme: const ColorScheme.dark(background: AppColors.darkGrey));
}
