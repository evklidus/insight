import 'package:flutter/services.dart';

class Flavor {
  static const _defaultFlavor = 'dev';

  static String get current => appFlavor ?? _defaultFlavor;
  static bool get isDev => current == _defaultFlavor;
  static bool get isProd => current == 'prod';
}
