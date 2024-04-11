import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  /// Returns [ColorScheme] from [BuildContext]
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns [TextTheme] from [BuildContext].
  TextTheme get textTheme => Theme.of(this).textTheme;
}
