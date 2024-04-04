import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton(
    this.connectionState,
    this.videoPlayerController, {
    super.key,
  });

  final ConnectionState connectionState;
  final VideoPlayerController videoPlayerController;

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with TickerProviderStateMixin {
  var isPlaying = true;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.connectionState == ConnectionState.done
        ? Theme.of(context).colorScheme.primary
        : Colors.grey;

    return GestureDetector(
      onTap: () {
        if (widget.connectionState == ConnectionState.done) {
          widget.videoPlayerController.value.isPlaying
              ? widget.videoPlayerController.pause()
              : widget.videoPlayerController.play();
        }
      },
      child: SizedBox(
        height: 75,
        width: 75,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.surface,
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
