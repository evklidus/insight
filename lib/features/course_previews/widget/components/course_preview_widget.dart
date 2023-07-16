import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            InsightImageWidget(
              coursePreview.imageUrl,
              width: 74,
              height: 74,
              borderRadius: BorderRadius.circular(15),
            ),
            const WBox(13),
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
