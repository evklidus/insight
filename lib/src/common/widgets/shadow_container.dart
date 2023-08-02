import 'package:flutter/material.dart';

@Deprecated('На данный момент нигде не нужен, возможно надо будет удалить')
class ShadowContainer extends StatelessWidget {
  const ShadowContainer({
    Key? key,
    required this.child,
    this.radius = 5,
    this.moreShadow = false,
    this.color = Colors.white,
    this.padding,
    this.customPadding,
    this.isCircle = false,
    this.topRounded = false,
    this.alignment,
    this.height,
    this.width,
  }) : super(key: key);

  final Widget child;
  final double radius;
  final bool moreShadow;
  final Color color;
  final double? padding;
  final EdgeInsets? customPadding;
  final bool isCircle;
  final bool topRounded;
  final Alignment? alignment;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: alignment,
      padding: customPadding ?? EdgeInsets.all(padding ?? 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: topRounded
            ? const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
            : (isCircle ? null : BorderRadius.circular(radius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(moreShadow ? 0.25 : 0.15),
            spreadRadius: moreShadow ? 2.5 : 1.5,
            blurRadius: 10,
          ),
        ],
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: child,
    );
  }
}
