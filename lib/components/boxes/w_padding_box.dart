import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WPaddingBox extends StatelessWidget {
  const WPaddingBox({Key? key, required this.child, this.padding})
      : super(key: key);

  final Widget child;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding ?? 16.w,
      ),
      child: child,
    );
  }
}
