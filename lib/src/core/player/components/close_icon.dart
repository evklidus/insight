import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon(this.onPressed, {super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isNeedCupertino = Platform.isIOS || Platform.isMacOS;

    return AdaptiveButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            12,
          ),
          color: context.colorScheme.surfaceContainerLow,
        ),
        child: SizedBox.square(
          child: Icon(
            isNeedCupertino ? CupertinoIcons.xmark : Icons.close,
            size: 24,
          ),
        ),
      ),
    );
  }
}
