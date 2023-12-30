import 'package:flutter/material.dart';

import 'package:insight/src/common/constants/app_strings.dart';

import 'package:insight/gen/assets.gen.dart';

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.reloadFunc,
  }) : super(key: key);

  InformationWidget.empty({
    Key? key,
    String? imagePath,
    this.title = AppStrings.oops,
    this.description = AppStrings.itemForgot,
    this.reloadFunc,
  })  : imagePath = imagePath ?? Assets.images.emptyImage.path,
        super(key: key);

  InformationWidget.error({
    Key? key,
    String? imagePath,
    this.title = AppStrings.error,
    this.description = AppStrings.somethingWrong,
    required this.reloadFunc,
  })  : imagePath = imagePath ?? Assets.images.errorImage.path,
        super(key: key);

  final String imagePath;
  final String title;
  final String description;
  final VoidCallback? reloadFunc;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
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
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (reloadFunc != null) const SizedBox(height: 8),
          if (reloadFunc != null)
            FilledButton(
              onPressed: reloadFunc,
              child: const Text(AppStrings.tryAgain),
            ),
        ],
      ),
    );
  }
}
