import 'package:flutter/material.dart';

import 'package:insight_player/src/insight_slider.dart';
import 'package:video_player/video_player.dart';
import 'close_icon.dart';
import 'play_pause_button.dart';
import 'video_widget.dart';

class InsightPlayer extends StatefulWidget {
  const InsightPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.onVideoEnd,
    required this.onCloseButtonPressed,
  });

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
    final videoUrl = Uri.parse(widget.videoUrl);
    _controller = VideoPlayerController.networkUrl(videoUrl);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height / 2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: VideoWidget(
                      connectionState: snapshot.connectionState,
                      controller: _controller,
                    ),
                  ),
                ),
                InsightSlider(_controller),
                PlayPauseButton(
                  snapshot.connectionState,
                  _controller,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
