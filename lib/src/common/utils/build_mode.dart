import 'package:flutter/foundation.dart';

class BuildMode {
  static String get current {
    if (kReleaseMode) {
      return 'release';
    } else if (kProfileMode) {
      return 'profile';
    } else {
      return 'debug';
    }
  }
}
