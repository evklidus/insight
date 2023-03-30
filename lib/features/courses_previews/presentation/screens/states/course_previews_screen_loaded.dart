import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/components/boxes/h_box.dart';
import 'package:insight/features/courses_previews/presentation/store/courses_preview_store.dart';
import 'package:insight/features/courses_previews/presentation/widgets/course_preview_widget.dart';
import 'package:provider/provider.dart';

class CoursePreviewsScreenLoaded extends StatelessWidget {
  const CoursePreviewsScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<CoursesPreviewStore>();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: store.entity!.length,
      itemBuilder: (context, index) => CoursePreviewWidget(
        coursePreview: store.entity![index],
      ),
      separatorBuilder: (context, index) => HBox(20.h),
    );
  }
}
