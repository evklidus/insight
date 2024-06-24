import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';

import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/features/course/bloc/course_bloc.dart';
import 'package:insight/src/features/course/model/course.dart';
import 'package:provider/provider.dart';

class CourseWidget extends StatelessWidget {
  const CourseWidget({
    super.key,
    required this.course,
    required this.categoryTag,
  });

  final Course course;
  final String categoryTag;

  void _onPressedHandler(BuildContext context) => context.goRelativeNamed(
        'page',
        pathParameters: {
          'coursePageId': course.id.toString(),
        },
        extra: () => Provider.of<CourseBloc>(context, listen: false).add(
          CourseEvent.fetch(categoryTag),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onPressedHandler(context),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
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
            Expanded(
              child: Text(
                course.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
              ),
            ),
            if (course.isItsOwn) ...[
              const SizedBox(width: 13),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: context.colorScheme.surfaceContainerHighest,
                  ),
                  child: Text(
                    'Ваш',
                    style: context.textTheme.labelLarge,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
