import 'package:flutter/material.dart';

import 'package:insight_player/src/insight_slider.dart';
import 'package:video_player/video_player.dart';
import 'close_icon.dart';
import 'play_pause_button.dart';
import 'video_widget.dart';

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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 15,
                  ),
                  child: Row(
                    children: [
                      CloseIcon(widget.onCloseButtonPressed),
                      const SizedBox(width: 10),
                      Text(
                        widget.title,
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
                InsightSlider(_controller),
                const Spacer(
                  flex: 3,
                ),
                PlayPauseButton(
                  snapshot.connectionState,
                  _controller,
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
