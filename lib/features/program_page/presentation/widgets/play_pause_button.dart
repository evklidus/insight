import 'package:flutter/material.dart';
import 'package:m_sport/core/constants/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

class _PlayPauseButtonState extends State<PlayPauseButton> with TickerProviderStateMixin {
  late final AnimationController _animationController;

  var isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.connectionState == ConnectionState.done ? ColorConstants.whiteScarlet : ColorConstants.white;
    final iconColor = widget.connectionState == ConnectionState.done ? ColorConstants.scarlet : ColorConstants.gray;
    final height = 17.w;
    const double radius = 20;

    return GestureDetector(
      onTap: () {
        if (widget.connectionState == ConnectionState.done) {
          widget.onTap();
          isAnimating = !isAnimating;
          isAnimating ? _animationController.forward() : _animationController.reverse();
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
              padding: const EdgeInsets.all(radius),
              color: backgroundColor,
              child: AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _animationController,
                color: iconColor,
              )),
        ),
      ),
    );
  }
}
