import 'package:flutter/material.dart';

import 'package:insight_player/src/insight_slider.dart';
import 'package:video_player/video_player.dart';
import 'close_icon.dart';
import 'play_pause_button.dart';

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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                AnimatedCrossFade(
                  crossFadeState:
                      snapshot.connectionState == ConnectionState.waiting
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 250),
                  firstChild: CircularProgressIndicator.adaptive(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  secondChild: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height / 2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
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
