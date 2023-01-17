import 'package:flutter/material.dart';
import 'package:insight/features/courses_previews/presentation/store/courses_preview_store.dart';
import 'package:insight/features/courses_previews/presentation/widgets/course_preview_widget.dart';
import 'package:provider/provider.dart';

class ProgramPageScreenLoaded extends StatelessWidget {
  const ProgramPageScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<CoursesPreviewStore>();
    return Column(
      children: store.entity!
          .map(
            (coursePreview) => CoursePreviewWidget(
              coursePreview: coursePreview,
            ),
          )
          .toList(),
    );
  }
}
