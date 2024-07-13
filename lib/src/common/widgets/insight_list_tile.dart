import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';

/// {@template insight_list_tile}
/// InsightListTile widget.
/// {@endtemplate}
class InsightListTile extends StatelessWidget {
  /// {@macro insight_list_tile}
  const InsightListTile({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.leadingSize = 28,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double leadingSize;
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => isNeedCupertino
      ? ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(24),
          child: CupertinoListTile(
            leadingSize: leadingSize,
            onTap: onTap,
            padding: padding ??
                const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
            backgroundColor: backgroundColor ??
                Theme.of(context).colorScheme.surfaceContainer,
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
          ),
        )
      :
      // Material нужен из-за этого бага - <https://github.com/flutter/flutter/issues/142085>
      Material(
          child: ListTile(
            onTap: onTap,
            contentPadding: padding,
            tileColor: backgroundColor ??
                Theme.of(context).colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(24),
            ),
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
          ),
        );
}
