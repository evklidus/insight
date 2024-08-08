import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';

/// {@template edit_button}
/// EditButton widget.
/// {@endtemplate}
class EditButton extends StatelessWidget {
  /// {@macro edit_button}
  const EditButton({
    super.key,
    required this.isEditing,
    this.opacity = 1,
    required this.onPressed,
  });

  final bool isEditing;
  final double opacity;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        duration: standartDuration,
        opacity: opacity,
        child: AdaptiveButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          child: Text(
            isEditing ? AppStrings.done : 'Изменить',
          ),
        ),
      );
}
