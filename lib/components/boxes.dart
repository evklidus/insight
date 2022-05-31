import 'package:flutter/material.dart';

class HBox extends StatelessWidget {
  const HBox(this.height, {Key? key}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class WBox extends StatelessWidget {
  const WBox(this.width, {Key? key}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class WPaddingBox extends StatelessWidget {
  const WPaddingBox({Key? key, required this.child, this.padding}) : super(key: key);

  final Widget child;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding ?? 16,
      ),
      child: child,
    );
  }
}
