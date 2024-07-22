import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';

import 'package:insight/src/features/course/bloc/course_bloc.dart';
import 'package:insight/src/features/course/model/course.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
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
    final profileBloc = Provider.of<ProfileBloc>(context);
    final isItsOwn = course.creatorId == profileBloc.state.data?.id;

    return InsightListTile(
      onTap: () => _onPressedHandler(context),
      padding: const EdgeInsets.all(16),
      leadingSize: 60,
      leading: CustomImageWidget(
        course.imageUrl,
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        course.name,
        style: Theme.of(context).textTheme.titleMedium,
        maxLines: 2,
      ),
      trailing: isItsOwn
          ? FittedBox(
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
            )
          : null,
    );
  }
}
