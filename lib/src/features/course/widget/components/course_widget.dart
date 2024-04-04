import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';

import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/features/course/model/course.dart';

class CourseWidget extends StatelessWidget {
  const CourseWidget({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goRelativeNamed(
        'page',
        pathParameters: {
          'coursePageId': course.id.toString(),
        },
      ),
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
            CustomImageWidget(
              course.imageUrl,
              width: 74,
              height: 74,
              borderRadius: BorderRadius.circular(15),
            ),
            const SizedBox(width: 13),
            Flexible(
              child: Text(
                course.name,
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
