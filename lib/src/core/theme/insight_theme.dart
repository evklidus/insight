import 'package:flutter/material.dart';

final class InsightTheme {
  ThemeData getLightTheme() {
    return ThemeData.light(
      useMaterial3: true,
    );
  }

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
          color: colorScheme.onBackground,
          fontSize: 40,
          shadows: [
            Shadow(
              color: colorScheme.primary,
              blurRadius: 20,
            ),
          ],
        ),
        bodyLarge: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 32,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodySmall: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
    );
  }
}
