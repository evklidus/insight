import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton(
    this.connectionState,
    this.isPlaying, {
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final ConnectionState connectionState;
  final bool isPlaying;
  final Function() onTap;

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
          setState(() {
            widget.onTap();
            isPlaying = !isPlaying;
          });
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: isPlaying
                  ? Icon(
                      CupertinoIcons.pause_fill,
                      size: 30.sp,
                      color: iconColor,
                    )
                  : Icon(
                      CupertinoIcons.play_fill,
                      size: 30.sp,
                      color: iconColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
