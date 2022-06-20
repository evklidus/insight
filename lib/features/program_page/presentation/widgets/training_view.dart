import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:m_sport/core/constants/color_constants.dart';
import 'package:m_sport/features/program_page/domain/entities/training_entity.dart';
import 'package:m_sport/services/navigation/app_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TrainingView extends StatelessWidget {
  const TrainingView({Key? key, required this.training}) : super(key: key);

  final TrainingEntity training;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 25,
      ),
      height: 9.h,
      width: 92.5.w,
      blur: 20,
      gradient: ColorConstants.trainingGradient,
      borderColor: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            training.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () async {
              await HapticFeedback.lightImpact();
              context.router.push(TrainingRoute(videoUrl: training.videoUrl));
            },
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
