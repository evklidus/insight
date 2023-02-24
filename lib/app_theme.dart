import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/core/constants/color_constants.dart';

class AppTheme {
  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );
  }

  ThemeData getDartTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xff1C1C1E),
      primaryColor: ColorConstants.primary,
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 40.sp,
          shadows: [
            Shadow(
              color: ColorConstants.primary,
              blurRadius: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}
