import 'package:flutter/material.dart';

class ColorConstants {
  // Gradients
  static const coursePageGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color.fromARGB(255, 77, 19, 87),
      Color.fromARGB(255, 58, 14, 66),
      Colors.black,
    ],
  );
  static const lessonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(34, 255, 255, 255),
      Color.fromARGB(17, 255, 255, 255),
    ],
  );
  static const shadowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(195, 0, 0, 0),
      Color.fromARGB(130, 0, 0, 0),
      Colors.transparent,
    ],
  );
}
