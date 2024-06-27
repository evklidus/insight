import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.title,
    this.textStyle,
    required this.icon,
    this.onTap,
  });

  final String title;
  final Widget icon;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyle,
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
