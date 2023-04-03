import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class InsightSlider extends StatefulWidget {
  const InsightSlider(this.videoPlayerController, {super.key});

  final VideoPlayerController videoPlayerController;

  @override
  State<InsightSlider> createState() => _InsightSliderState();
}

class _InsightSliderState extends State<InsightSlider> {
  String formatSeconds(int seconds) {
    String minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    String remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: widget.videoPlayerController,
            builder: (context, value, _) {
              return SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: value.position.inSeconds.toDouble(),
                  min: 0.0,
                  max: value.duration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    widget.videoPlayerController
                        .seekTo(Duration(seconds: value.toInt()));
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: widget.videoPlayerController,
                builder: (context, value, _) {
                  return Text(
                    formatSeconds(
                      value.position.inSeconds,
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                  );
                },
              ),
              Text(
                formatSeconds(
                  widget.videoPlayerController.value.duration.inSeconds,
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
