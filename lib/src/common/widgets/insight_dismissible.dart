import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';

/// {@template insight_dismissible}
/// InsightDismissible widget.
/// {@endtemplate}
class InsightDismissible extends StatefulWidget {
  /// {@macro insight_dismissible}
  const InsightDismissible({
    required this.itemKey,
    required this.child,
    this.isEnabled = true,
    required this.deleteHandler,
    super.key,
  });

  final Widget child;
  final Object itemKey;
  final bool isEnabled;
  final VoidCallback deleteHandler;

  @override
  State<InsightDismissible> createState() => _InsightDismissibleState();
}

/// State for widget InsightDismissible.
class _InsightDismissibleState extends State<InsightDismissible> {
  double swipeProgress = 0;
  final _dismissValue = 0.35;

  bool _isDeletConfirmed = false;

  void confirmDismiss() {
    _isDeletConfirmed = true;
    context.pop();
    widget.deleteHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.itemKey),
      direction: widget.isEnabled
          ? DismissDirection.endToStart
          : DismissDirection.none,
      dismissThresholds: {DismissDirection.endToStart: _dismissValue},
      confirmDismiss: (direction) async {
        if (swipeProgress == 1) {
          await showAdaptiveDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: const Text('Подтверждение'),
              content: const Text('Вы действительно хотитете удалить урок ?'),
              actions: [
                Platform.isIOS
                    ? CupertinoDialogAction(
                        onPressed: confirmDismiss,
                        child: const Text('Удалить'),
                      )
                    : TextButton(
                        onPressed: confirmDismiss,
                        child: const Text('Удалить'),
                      ),
                Platform.isIOS
                    ? CupertinoDialogAction(
                        onPressed: context.pop,
                        isDefaultAction: true,
                        child: const Text('Отменить'),
                      )
                    : TextButton(
                        onPressed: context.pop,
                        child: const Text('Отменить'),
                      ),
              ],
            ),
          );
        }
        return _isDeletConfirmed;
      },
      onUpdate: (details) {
        if (details.progress <= _dismissValue) {
          swipeProgress = details.progress / _dismissValue;
        } else if (details.progress > _dismissValue) {
          swipeProgress = 1;
        }
        setState(() {});
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: swipeProgress,
              child: Icon(
                Platform.isIOS ? CupertinoIcons.delete : Icons.delete,
                color: context.colorScheme.error,
                size: 20,
              ),
            ),
            Opacity(
              opacity: swipeProgress,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: context.colorScheme.surfaceContainerHighest,
                value: swipeProgress,
              ),
            ),
          ],
        ),
      ),
      child: widget.child,
    );
  }
}
