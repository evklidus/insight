import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/common/constants/app_strings.dart';
import 'package:insight/common/widgets/boxes/h_box.dart';
import 'package:insight/common/widgets/boxes/w_padding_box.dart';
import 'package:insight/gen/assets.gen.dart';

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.reloadFunc,
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
    this.reloadFunc,
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
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
              style: TextStyle(
                fontSize: 21.sp,
                color: Colors.white,
              ),
            ),
            HBox(3.h),
            WPaddingBox(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            HBox(2.h),
            if (reloadFunc != null)
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
