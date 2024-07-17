import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                  onPressed: context.back,
                  isDefaultAction: true,
                  child: const Text('Окей'),
                )
              : TextButton(
                  onPressed: context.back,
                  child: const Text('Окей'),
                ),
        ],
      ),
    );
