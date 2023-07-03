import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/common/widgets/boxes/w_box.dart';
import 'package:insight/common/widgets/insight_image_widget.dart';
import 'package:insight/features/course_previews/data/entities/course_preview_entity.dart';
import 'package:insight/core/navigation/app_router.dart';

class CoursePreviewWidget extends StatelessWidget {
  const CoursePreviewWidget({
    Key? key,
    required this.coursePreview,
  }) : super(key: key);

  final CoursePreviewEntity coursePreview;

  @override
  Widget build(BuildContext context) {
    final imageWidth = 74.w;
    return GestureDetector(
      onTap: () {
        context.pushRoute(
          CoursePageRoute(
            coursePageId: coursePreview.id,
            coursePageTitle: coursePreview.name,
          ),
        );
      },
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        padding: EdgeInsets.all(13.r),
        child: Row(
          children: [
            InsightImageWidget(
              coursePreview.imageUrl,
              width: imageWidth,
              height: imageWidth,
              borderRadius: 15.r,
            ),
            WBox(13.w),
            Flexible(
              child: Text(
                coursePreview.name,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
