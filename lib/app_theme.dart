import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _fonSize20 = 20.sp;

class AppTheme {
  ThemeData getLightTheme() {
    return ThemeData.light(
      useMaterial3: true,
    );
  }

  // TODO: Fix ignore
  // ignore: long-method
  ThemeData getDarkTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff3965E3),
      onPrimary: Colors.black,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white,
      background: Color(0xff1C1C1E),
      onBackground: Colors.white,
      surface: Color(0xff333334),
      onSurface: Color(0xff3965E3),
    );

    return ThemeData(
      iconTheme: IconThemeData(color: colorScheme.primary),
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colorScheme.background,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        surfaceTintColor: colorScheme.background,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 40.sp,
          shadows: [
            Shadow(
              color: colorScheme.primary,
              blurRadius: 20.r,
            ),
          ],
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: _fonSize20,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: _fonSize20,
          fontWeight: FontWeight.normal,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
    );
  }
}
