import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton(
    this.isInitialized,
    this.videoPlayerController, {
    super.key,
  });

  final bool isInitialized;
  final VideoPlayerController videoPlayerController;

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with TickerProviderStateMixin {
  var isPlaying = true;

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final iconColor = widget.isInitialized
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.4);

    return GestureDetector(
      onTap: widget.isInitialized
          ? () {
              widget.videoPlayerController.value.isPlaying
                  ? widget.videoPlayerController.pause()
                  : widget.videoPlayerController.play();
            }
          : null,
      child: SizedBox.square(
        dimension: query.size.shortestSide / 5.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: widget.videoPlayerController,
              builder: (context, value, _) {
                return AnimatedSwitcher(
                  switchInCurve: Curves.bounceIn,
                  switchOutCurve: Curves.bounceOut,
                  duration: const Duration(milliseconds: 150),
                  child: value.isPlaying
                      ? Icon(
                          CupertinoIcons.pause_fill,
                          size: 30,
                          color: iconColor,
                          key: const ValueKey('PauseIcon'),
                        )
                      : Icon(
                          CupertinoIcons.play_fill,
                          size: 30,
                          color: iconColor,
                          key: const ValueKey('PlayIcon'),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
