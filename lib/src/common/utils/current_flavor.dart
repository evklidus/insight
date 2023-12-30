import 'package:flutter/services.dart';

class CurrentFlavor {
  static const isDev = appFlavor == 'dev';
  static const isProd = appFlavor == 'prod';
}
