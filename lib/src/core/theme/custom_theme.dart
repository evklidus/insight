import 'package:flutter/material.dart';

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
  seedColor: const Color(0xff3965E3),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff3965E3),
  onPrimary: Colors.white,
  secondary: Colors.white,
  onSecondary: Colors.black,
  error: Colors.redAccent,
  onError: Colors.white,
  background: Color(0xff1C1C1E),
  onBackground: Colors.white,
  surface: Color(0xff333334),
  onSurface: Colors.white,
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

const iconTheme = IconThemeData(color: Color(0xff3965E3));

final dividerTheme = DividerThemeData(
  color: Colors.grey.shade800,
  space: 0,
);
