import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/components/boxes/w_box.dart';
import 'package:insight/features/courses_previews/domain/entities/course_preview_entity.dart';
import 'package:insight/services/navigation/app_router.dart';

class CoursePreviewWidget extends StatelessWidget {
  const CoursePreviewWidget({Key? key, required this.coursePreview})
      : super(key: key);

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
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.network(
                coursePreview.imageUrl,
                width: imageWidth,
                height: imageWidth,
                fit: BoxFit.cover,
              ),
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
