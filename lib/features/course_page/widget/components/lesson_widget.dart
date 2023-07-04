import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:insight/features/course_page/data/entities/lesson_entity.dart';
import 'package:insight/core/navigation/app_router.dart';

class LessonWidget extends StatelessWidget {
  const LessonWidget(this.lesson, {Key? key}) : super(key: key);

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 70,
      padding: const EdgeInsets.only(left: 15, right: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lesson.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.play_fill),
            iconSize: 30,
            onPressed: () => context.pushRoute(
              InsightPlayerRoute(
                videoUrl: lesson.videoUrl,
                title: lesson.name,
                onVideoEnd: () => context.router.pop(),
                onCloseButtonPressed: () => context.router.pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
