import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:insight/core/constants/color_constants.dart';
import 'package:insight/features/course_page/domain/entities/lesson_entity.dart';
import 'package:insight/services/navigation/app_router.dart';

class LessonView extends StatelessWidget {
  const LessonView({Key? key, required this.lesson}) : super(key: key);

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pushRoute(LessonRoute(videoUrl: lesson.videoUrl));
      },
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 25,
        ),
        height: 9.h,
        width: 92.5.w,
        blur: 20,
        gradient: ColorConstants.lessonGradient,
        borderColor: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lesson.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
