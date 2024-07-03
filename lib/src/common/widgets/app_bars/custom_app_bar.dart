import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
    this.leadingText, {
    super.key,
    this.onTap,
    this.action,
  });

  final String? leadingText;
  final Function? onTap;

  final Widget? action;

  bool get _hasLeadingText => leadingText != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RoundedBackButton(onTap: onTap),
          if (_hasLeadingText)
            Text(
              leadingText!,
              style: context.textTheme.titleLarge,
            ),
          if (action.isNotNull) ...[
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: action!,
            ),
          ]
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _RoundedBackButton extends StatelessWidget {
  const _RoundedBackButton({this.onTap});

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return isNeddCupertino
        ? CupertinoButton(
            onPressed: () => onTap?.call() ?? context.pop(),
            child: const Icon(
              CupertinoIcons.chevron_left,
              size: 32,
            ),
          )
        : MaterialButton(
            onPressed: () => onTap?.call() ?? context.pop(),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.chevron_left,
              size: 32,
            ),
          );
  }
}
