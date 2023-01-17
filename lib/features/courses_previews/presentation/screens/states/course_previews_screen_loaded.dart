import 'package:flutter/material.dart';
import 'package:insight/features/courses_previews/presentation/store/courses_preview_store.dart';
import 'package:insight/features/courses_previews/presentation/widgets/course_preview_widget.dart';
import 'package:provider/provider.dart';

class CoursePreviewsScreenLoaded extends StatelessWidget {
  const CoursePreviewsScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<CoursesPreviewStore>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: store.entity!
            .map(
              (coursePreview) =>
                  CoursePreviewWidget(coursePreview: coursePreview),
            )
            .toList(),
      ),
    );
  }
}
