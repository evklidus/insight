import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/shimmer.dart';

import 'package:insight/src/features/course/model/course.dart';
import 'package:insight/src/features/course/widget/components/course_widget.dart';

class CourseList extends StatelessWidget {
  const CourseList({
    super.key,
    required this.courses,
    required this.categoryTag,
  });

  final List<Course>? courses;
  final String categoryTag;

  @override
  Widget build(BuildContext context) {
    ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount)
    return courses.isNotNull
        ? Column(
            children: courses!
                .map(
                  (course) => Padding(
                    padding: EdgeInsets.only(
                        top: courses!.indexOf(course) == 0 ? 0 : 20),
                    child: CourseWidget(
                      course: course,
                      categoryTag: categoryTag,
                    ),
                  ),
                )
                .toList(),
          )
        : Column(
            children: List.generate(
              5,
              (index) => const Shimmer(
                size: Size.fromHeight(100),
              ),
            ),
          );
  }
}
