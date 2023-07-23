import 'package:flutter/material.dart';

class HBox extends StatelessWidget {
  const HBox(this.height, {Key? key}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
