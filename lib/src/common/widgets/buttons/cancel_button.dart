import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';

/// {@template edit_button}
/// CancelButton widget.
/// {@endtemplate}
class CancelButton extends StatelessWidget {
  /// {@macro edit_button}
  const CancelButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => AdaptiveButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: const Text(AppStrings.cancel),
      );
}
