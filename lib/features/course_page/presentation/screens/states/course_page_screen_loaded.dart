import 'package:flutter/material.dart';
import 'package:insight/features/course_page/presentation/store/course_page_store.dart';
import 'package:insight/features/course_page/presentation/widgets/lesson_view.dart';
import 'package:provider/provider.dart';

class CoursePageScreenLoaded extends StatelessWidget {
  const CoursePageScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<CoursePageStore>();
    return Column(
      children: store.entity!.lessons
          .map(
            (lesson) => LessonView(
              lesson: lesson,
            ),
          )
          .toList(),
    );
  }
}
