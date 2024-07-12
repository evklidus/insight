import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';

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
    return InsightListTile(
      onTap: onTap,
      backgroundColor: context.colorScheme.surfaceContainerLow,
      leading: icon,
      title: Text(
        title,
        style: context.textTheme.titleMedium,
      ),
    );
  }
}
