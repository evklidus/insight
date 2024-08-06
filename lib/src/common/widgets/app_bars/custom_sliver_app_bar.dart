import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';

/// {@template custom_sliver_app_bar}
/// CustomSliverAppBar widget.
/// {@endtemplate}
class CustomSliverAppBar extends StatelessWidget {
  /// {@macro custom_sliver_app_bar}
  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.previousPageTitle,
    this.action,
  });

  final String? title;
  final String? previousPageTitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) => isNeedCupertino
      ? CupertinoSliverNavigationBar(
          automaticallyImplyTitle: false,
          previousPageTitle: previousPageTitle,
          largeTitle: title.isNotNull ? Text(title!) : null,
          trailing: action,
        )
      : SliverAppBar(
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
