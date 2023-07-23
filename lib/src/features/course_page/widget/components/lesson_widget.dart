import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/extensions/go_relative_named.dart';

import 'package:insight/src/features/course_page/model/lesson.dart';

class LessonWidget extends StatelessWidget {
  const LessonWidget(this.lesson, {Key? key}) : super(key: key);

  final Lesson lesson;

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
            onPressed: () => context.goRelativeNamed(
              'video',
              pathParameters: {
                'coursePageTitle': lesson.name,
              },
              extra: lesson.videoUrl,
            ),
          ),
        ],
      ),
    );
  }
}
