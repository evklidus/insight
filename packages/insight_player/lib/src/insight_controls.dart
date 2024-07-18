import 'package:flutter/material.dart';
import 'package:insight_player/src/custom_video_progress_indicator.dart';
import 'package:insight_player/src/play_pause_button.dart';
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
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.4);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Column(
        children: [
          CustomVideoProgressIndicator(
            controller,
            allowScrubbing: true,
            borderRadius: BorderRadius.circular(12),
            colors: VideoProgressColors(
              playedColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => controller.seekTo(
                  Duration(
                    seconds: controller.value.position.inSeconds - 15,
                  ),
                ),
                icon: Icon(
                  Icons.replay_10_rounded,
                  size: 32,
                  color: iconColor,
                ),
              ),
              PlayPauseButton(
                isInitialized,
                controller,
              ),
              IconButton(
                onPressed: () => controller.seekTo(
                  Duration(
                    seconds: controller.value.position.inSeconds + 15,
                  ),
                ),
                icon: Icon(
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
