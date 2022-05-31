import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const Color skeletonGradientBegin = Color(0xFFF9F9F9);
const Color skeletonGradientEnd = Color(0xFFE9E9E9);

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    Key? key,
    this.height = 8,
    this.width = double.maxFinite,
    this.linearGradient = const LinearGradient(
      colors: [skeletonGradientBegin, skeletonGradientEnd],
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
    ),
    this.radius,
  }) : super(key: key);

  final double height;
  final double width;
  final double? radius;
  final LinearGradient linearGradient;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(gradient: linearGradient);
    Widget body = Container(width: width, height: height, decoration: decoration);

    if (radius != null) {
      body = ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius!)),
        child: body,
      );
    }

    return Shimmer.fromColors(
      child: body,
      baseColor: Color.fromARGB(255, 208, 208, 208),
      highlightColor: Colors.white,
    );
  }
}
