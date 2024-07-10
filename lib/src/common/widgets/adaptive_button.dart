import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';

/// {@template adaptive_button}
/// AdaptiveButton widget.
/// {@endtemplate}
class AdaptiveButton extends StatelessWidget {
  /// {@macro adaptive_button}
  const AdaptiveButton({
    required this.onPressed,
    required this.child,
    this.padding,
    this.borderRadius,
    super.key,
  }) : _isFilled = false;

  const AdaptiveButton.filled({
    required this.onPressed,
    required this.child,
    this.padding,
    this.borderRadius,
    super.key,
  }) : _isFilled = true;

  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool _isFilled;

  @override
  Widget build(BuildContext context) => isNeedCupertino
      ? _isFilled
          ? CupertinoButton.filled(
              padding: padding,
              borderRadius: borderRadius,
              onPressed: onPressed,
              child: child,
            )
          : CupertinoButton(
              padding: padding,
              onPressed: onPressed,
              child: child,
            )
      : _isFilled
          ? FilledButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(padding),
              ),
              onPressed: onPressed,
              child: child,
            )
          : TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(padding),
              ),
              onPressed: onPressed,
              child: child,
            );
}
