import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/components/boxes/w_padding_box.dart';
import 'package:video_player/video_player.dart';

class LessonVideo extends StatelessWidget {
  const LessonVideo({
    Key? key,
    required this.connectionState,
    required this.controller,
  }) : super(key: key);

  final ConnectionState connectionState;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return WPaddingBox(
      child: AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 800),
        child: connectionState == ConnectionState.done
            ? ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
