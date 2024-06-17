import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// {@template adaptive_button}
/// AdaptiveButton widget.
/// {@endtemplate}
class AdaptiveButton extends StatelessWidget {
  /// {@macro adaptive_button}
  const AdaptiveButton({
    required this.onPressed,
    required this.child,
    super.key,
  }) : _isFilled = false;

  const AdaptiveButton.filled({
    required this.onPressed,
    required this.child,
    super.key,
  }) : _isFilled = true;

  final VoidCallback onPressed;
  final Widget child;
  final bool _isFilled;

  @override
  Widget build(BuildContext context) => _isFilled
      ? Platform.isIOS
          ? CupertinoButton.filled(
              onPressed: onPressed,
              child: child,
            )
          : FilledButton(
              onPressed: onPressed,
              child: child,
            )
      : Platform.isIOS
          ? CupertinoButton(
              onPressed: onPressed,
              child: child,
            )
          : TextButton(
              onPressed: onPressed,
              child: child,
            );
}
