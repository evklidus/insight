import 'package:flutter/material.dart';

import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/boxes/h_box.dart';
import 'package:insight/src/common/widgets/boxes/w_padding_box.dart';
import 'package:insight/gen/assets.gen.dart';

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.reloadFunc,
  }) : super(key: key);

  InformationWidget.idle({
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
  final Function()? reloadFunc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Column(
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
                fontSize: 21,
                color: Colors.white,
              ),
            ),
            const HBox(3),
            WPaddingBox(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const HBox(2),
            TextButton(
              onPressed: reloadFunc,
              child: const Text(AppStrings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
