import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';

class CustomAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.previousPageTitle,
    this.leading,
    this.title,
    this.action,
  });

  final String? previousPageTitle;
  final Widget? leading;
  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return isNeedCupertino
        ? CupertinoNavigationBar(
            previousPageTitle: previousPageTitle,
            leading: leading,
            middle: title.isNotNull
                ? Text(
                    title!,
                    style: context.textTheme.titleMedium,
                  )
                : null,
            trailing: action,
          )
        : AppBar(
            leading: leading,
            title: title.isNotNull ? Text(title!) : null,
            actions: action.isNotNull
                ? [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: action!,
                    )
                  ]
                : null,
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        isNeedCupertino ? kMinInteractiveDimensionCupertino : kToolbarHeight,
      );

  @override
  bool shouldFullyObstruct(BuildContext context) => false;
}
