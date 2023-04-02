import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'src/close_icon.dart';
import 'src/play_pause_button.dart';
import 'src/video_widget.dart';

class InsightPlayer extends StatefulWidget {
  const InsightPlayer({
    Key? key,
    required this.videoUrl,
    required this.title,
    required this.onVideoEnd,
    required this.onCloseButtonPressed,
  }) : super(key: key);

  final String videoUrl;
  final String title;
  final VoidCallback onVideoEnd;
  final VoidCallback onCloseButtonPressed;

  @override
  State<InsightPlayer> createState() => _InsightPlayerState();
}

class _InsightPlayerState extends State<InsightPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then(
          (value) => _controller.addListener(
            () {
              final bool isEndOfVideo =
                  _controller.value.position >= _controller.value.duration;

              if (isEndOfVideo) {
                widget.onVideoEnd();
              }
            },
          ),
        );
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 15.h,
                    ),
                    child: Row(
                      children: [
                        CloseIcon(widget.onCloseButtonPressed),
                        SizedBox(width: 10.w),
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  VideoWidget(
                    connectionState: snapshot.connectionState,
                    controller: _controller,
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  PlayPauseButton(
                    snapshot.connectionState,
                    _controller.value.isPlaying,
                    onTap: () {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    },
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}