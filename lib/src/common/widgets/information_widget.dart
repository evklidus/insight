import 'package:flutter/material.dart';

import 'package:insight/src/common/constants/app_strings.dart';

import 'package:insight/gen/assets.gen.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.reloadFunc,
  });

  InformationWidget.empty({
    super.key,
    String? imagePath,
    this.title = AppStrings.oops,
    this.description = AppStrings.itemForgot,
    this.reloadFunc,
  }) : imagePath = imagePath ?? Assets.images.emptyImage.path;

  InformationWidget.error({
    super.key,
    String? imagePath,
    this.title = AppStrings.error,
    this.description = AppStrings.somethingWrong,
    required this.reloadFunc,
  }) : imagePath = imagePath ?? Assets.images.errorImage.path;

  final String imagePath;
  final String title;
  final String description;
  final VoidCallback? reloadFunc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(imagePath),
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              if (reloadFunc != null) ...[
                const SizedBox(height: 24),
                AdaptiveButton.filled(
                  onPressed: reloadFunc,
                  child: const Text(AppStrings.tryAgain),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
