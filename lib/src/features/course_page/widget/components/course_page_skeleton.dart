import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/shimmer.dart';

/// {@template course_page_skeleton}
/// CoursePageSkeleton widget.
/// {@endtemplate}
class CoursePageSkeleton extends StatelessWidget {
  /// {@macro course_page_skeleton}
  const CoursePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AspectRatio(
          aspectRatio: 4 / 3,
          child: Shimmer(cornerRadius: 28),
        ),
        const SizedBox(height: 20),
        Shimmer(size: Size(size.width / 1.2, 35)),
        const SizedBox(height: 15),
        const Shimmer(),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) => const Shimmer(
            size: Size.fromHeight(60),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
        )
      ],
    );
  }
}
