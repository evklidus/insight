import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';
import 'package:insight/src/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';

class LessonWidget extends StatelessWidget {
  const LessonWidget(this.lesson, {super.key, this.courseId});

  final Lesson lesson;
  final String? courseId;

  Future<void> _onTap(BuildContext context) async {
    await context.pushNamed(
      RouteKeys.video.name,
      pathParameters: {
        'coursePageTitle': lesson.name,
      },
      queryParameters: {
        'videoUrl': resolveStorageUrl(lesson.videoUrl),
        if (courseId != null) 'courseId': courseId,
        if (courseId != null && lesson.id.isNotEmpty) 'lessonId': lesson.id,
      },
    );
    if (context.mounted && courseId != null) {
      context.read<CoursePageBloc>().add(CoursePageEvent.fetch(courseId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InsightListTile(
      onTap: () => _onTap(context),
      title: Text(
        lesson.name,
        maxLines: 2,
        style: context.textTheme.bodyLarge,
      ),
      trailing: Icon(
        lesson.completed
            ? (isNeedCupertino
                ? CupertinoIcons.check_mark_circled_solid
                : Icons.check_circle)
            : (isNeedCupertino
                ? CupertinoIcons.play_fill
                : Icons.play_arrow_rounded),
        size: 30,
      ),
    );
  }
}
