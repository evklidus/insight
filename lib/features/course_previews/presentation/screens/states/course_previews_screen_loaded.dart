import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/common/widgets/boxes/h_box.dart';
import 'package:insight/features/course_previews/domain/entities/course_preview_entity.dart';
import 'package:insight/features/course_previews/presentation/widgets/course_preview_widget.dart';

class CoursePreviewsScreenLoaded extends StatelessWidget {
  const CoursePreviewsScreenLoaded({
    Key? key,
    required this.coursePreviews,
  }) : super(key: key);

  final List<CoursePreviewEntity> coursePreviews;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: coursePreviews.length,
      itemBuilder: (context, index) => CoursePreviewWidget(
        coursePreview: coursePreviews[index],
      ),
      separatorBuilder: (context, index) => HBox(20.h),
    );
  }
}
