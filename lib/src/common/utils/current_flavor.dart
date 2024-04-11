import 'package:flutter/services.dart';

class Flavor {
  static String get current => appFlavor ?? 'No flavors';
  static bool get isDev => appFlavor == 'dev';
  static bool get isProd => appFlavor == 'prod';
}
