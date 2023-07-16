import 'package:flutter/material.dart';

import 'package:insight/common/constants/app_strings.dart';
import 'package:insight/common/widgets/boxes/h_box.dart';
import 'package:insight/common/widgets/insight_image_widget.dart';
import 'package:insight/features/course_page/data/entities/course_page_entity.dart';
import 'package:insight/features/course_page/widget/components/lesson_widget.dart';

class CoursePageScreenLoaded extends StatefulWidget {
  const CoursePageScreenLoaded({
    Key? key,
    required this.coursePageEntity,
  }) : super(key: key);

  final CoursePageEntity coursePageEntity;

  @override
  State<CoursePageScreenLoaded> createState() => _CoursePageScreenLoadedState();
}

class _CoursePageScreenLoadedState extends State<CoursePageScreenLoaded> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HBox(20),
            InsightImageWidget(
              widget.coursePageEntity.imageUrl,
              height: 190,
              width: double.infinity,
              borderRadius: BorderRadius.circular(30),
            ),
            const HBox(20),
            Text(
              AppStrings.lessons,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const HBox(20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.coursePageEntity.lessons.length,
              itemBuilder: (context, index) =>
                  LessonWidget(widget.coursePageEntity.lessons[index]),
              separatorBuilder: (context, index) => const HBox(20),
            ),
          ],
        ),
      ),
    );
  }
}
