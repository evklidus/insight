import 'package:flutter/material.dart';

import 'package:insight/src/features/course/model/course.dart';
import 'package:insight/src/features/course/widget/components/course_widget.dart';

class CourseList extends StatelessWidget {
  const CourseList({
    super.key,
    required this.courses,
  });

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) => CourseWidget(
        course: courses[index],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}
