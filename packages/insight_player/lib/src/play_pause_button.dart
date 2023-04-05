import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton(
    this.connectionState,
    this.videoPlayerController, {
    Key? key,
  }) : super(key: key);

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
    final height = 75.w;
    final radius = 20.r;

    return GestureDetector(
      onTap: () {
        if (widget.connectionState == ConnectionState.done) {
          widget.videoPlayerController.value.isPlaying
              ? widget.videoPlayerController.pause()
              : widget.videoPlayerController.play();
        }
      },
      child: SizedBox(
        height: height,
        width: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            alignment: Alignment.center,
            padding: EdgeInsets.all(radius),
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
                          size: 30.sp,
                          color: iconColor,
                          key: const ValueKey('PauseIcon'),
                        )
                      : Icon(
                          CupertinoIcons.play_fill,
                          size: 30.sp,
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
