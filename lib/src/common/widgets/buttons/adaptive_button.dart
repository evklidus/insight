import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';

/// {@template adaptive_button}
/// AdaptiveButton widget.
/// {@endtemplate}
class AdaptiveButton extends StatelessWidget {
  /// {@macro adaptive_button}
  const AdaptiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.padding,
    this.borderRadius,
  }) : _isFilled = false;

  const AdaptiveButton.filled({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.padding,
    this.borderRadius,
  }) : _isFilled = true;

  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool _isFilled;

  @override
  Widget build(BuildContext context) => isNeedCupertino
      ? _isFilled
          ? CupertinoButton.filled(
              padding: padding,
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              onPressed: onPressed,
              child: child,
            )
          : CupertinoButton(
              padding: padding,
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              color: color,
              onPressed: onPressed,
              child: child,
            )
      : _isFilled
          ? FilledButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(padding),
                backgroundColor: WidgetStateProperty.all(color),
              ),
              onPressed: onPressed,
              child: child,
            )
          : TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(padding),
                backgroundColor: WidgetStateProperty.all(color),
              ),
              onPressed: onPressed,
              child: child,
            );
}
