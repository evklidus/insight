import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/separated_column.dart';
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
    return courses.isNotNull
        ? SeparatedColumn(
            itemCount: courses!.length,
            itemBuilder: (context, index) => CourseWidget(
              course: courses![index],
              categoryTag: categoryTag,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          )
        : SeparatedColumn(
            itemCount: 5,
            itemBuilder: (context, index) => const Shimmer(
              size: Size.fromHeight(100),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          );
  }
}
