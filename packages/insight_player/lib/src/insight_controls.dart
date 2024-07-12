import 'package:flutter/material.dart';
import 'package:insight_player/src/play_pause_button.dart';
import 'package:video_player/video_player.dart';

/// {@template insight_controls}
/// InsightControls widget.
/// {@endtemplate}
class InsightControls extends StatefulWidget {
  /// {@macro insight_controls}
  const InsightControls({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  State<InsightControls> createState() => _InsightControlsState();
}

/// State for widget InsightControls.
class _InsightControlsState extends State<InsightControls> {
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
  }

  @override
  void didUpdateWidget(InsightControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) {
    final isInitialized = widget.controller.value.isInitialized;
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
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: VideoProgressIndicator(
              widget.controller,
              allowScrubbing: true,
              padding: EdgeInsets.zero,
              colors: VideoProgressColors(
                playedColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => widget.controller.seekTo(
                  Duration(
                    seconds: widget.controller.value.position.inSeconds - 15,
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
                widget.controller,
              ),
              IconButton(
                onPressed: () => widget.controller.seekTo(
                  Duration(
                    seconds: widget.controller.value.position.inSeconds + 15,
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
