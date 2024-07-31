import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';

import 'package:insight/src/features/course_page/model/lesson.dart';

class LessonWidget extends StatelessWidget {
  const LessonWidget(this.lesson, {super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return InsightListTile(
      onTap: () => context.pushNamed(
        RouteKeys.video.name,
        pathParameters: {
          'coursePageTitle': lesson.name,
        },
        queryParameters: {
          'videoUrl': lesson.videoUrl,
        },
      ),
      title: Text(
        lesson.name,
        maxLines: 2,
        style: context.textTheme.bodyLarge,
      ),
      trailing: Icon(
        isNeedCupertino ? CupertinoIcons.play_fill : Icons.play_arrow_rounded,
        size: 30,
      ),
    );
  }
}
