import 'package:flutter/material.dart';

const _primaryColor = Color(0xff3965E3);

final lightThemeData = ThemeData(
  colorScheme: lightColorScheme,
  textTheme: textTheme,
  iconTheme: iconTheme,
  dividerTheme: dividerTheme,
  brightness: Brightness.light,
  useMaterial3: true,
);

final darkThemeData = ThemeData(
  colorScheme: darkColorScheme,
  textTheme: textTheme,
  iconTheme: iconTheme,
  dividerTheme: dividerTheme,
  brightness: Brightness.dark,
  useMaterial3: true,
);

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: _primaryColor,
  primary: _primaryColor,
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: _primaryColor,
  primary: _primaryColor,
  brightness: Brightness.dark,
  secondary: Colors.white,
  error: Colors.redAccent,
  surface: const Color.fromARGB(255, 48, 48, 52),
);

const textTheme = TextTheme(
  titleLarge: TextStyle(
    fontSize: 32,
  ),
  bodyMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  bodySmall: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
  ),
);

const iconTheme = IconThemeData(color: _primaryColor);

final dividerTheme = DividerThemeData(
  color: Colors.grey.shade800,
  space: 0,
);
