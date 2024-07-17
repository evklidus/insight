import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showCustomAlert(
  BuildContext context, {
  required String title,
  required String description,
}) =>
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(description),
        actions: [
          Platform.isIOS
              ? CupertinoDialogAction(
                  onPressed: context.pop,
                  isDefaultAction: true,
                  child: const Text('Окей'),
                )
              : TextButton(
                  onPressed: context.pop,
                  child: const Text('Окей'),
                ),
        ],
      ),
    );
