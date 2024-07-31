import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'custom_video_progress_indicator.dart';
import 'play_pause_button.dart';
import 'package:video_player/video_player.dart';

/// {@template insight_controls}
/// InsightControls widget.
/// {@endtemplate}
class InsightControls extends StatelessWidget {
  /// {@macro insight_controls}
  const InsightControls({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final isInitialized = controller.value.isInitialized;
    final iconColor = isInitialized
        ? (isNeedCupertino
            ? CupertinoTheme.of(context).primaryColor
            : context.colorScheme.primary)
        : context.colorScheme.onSurface.withOpacity(0.4);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        color: context.colorScheme.surfaceContainerLow,
      ),
      child: Column(
        children: [
          CustomVideoProgressIndicator(
            controller,
            allowScrubbing: true,
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(vertical: 6),
            colors: VideoProgressColors(
              playedColor: iconColor,
              backgroundColor: iconColor.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AdaptiveButton(
                onPressed: () => controller.seekTo(
                  Duration(
                    seconds: controller.value.position.inSeconds - 15,
                  ),
                ),
                child: Icon(
                  Icons.replay_10_rounded,
                  size: 32,
                  color: iconColor,
                ),
              ),
              PlayPauseButton(
                isInitialized,
                controller,
              ),
              AdaptiveButton(
                onPressed: () => controller.seekTo(
                  Duration(
                    seconds: controller.value.position.inSeconds + 15,
                  ),
                ),
                child: Icon(
                  Icons.forward_10_rounded,
                  size: 32,
                  color: iconColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
