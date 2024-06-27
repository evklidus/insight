import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoundedBackButton extends StatelessWidget {
  const RoundedBackButton({super.key, this.onTap});

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call() ?? context.pop(),
      child: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(right: 1),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: const FittedBox(
          fit: BoxFit.cover,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
    );
  }
}
