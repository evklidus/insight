import 'package:flutter/material.dart';
import 'package:insight_player/src/insight_controls.dart';
import 'package:video_player/video_player.dart';
import 'close_icon.dart';

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

  void _videoListener() {
    final isEndOfVideo =
        _controller.value.position >= _controller.value.duration;

    if (isEndOfVideo) {
      _controller.removeListener(_videoListener);
      widget.onVideoEnd();
    }
  }

  @override
  void initState() {
    super.initState();
    final videoUrl = Uri.parse(widget.videoUrl);
    _controller = VideoPlayerController.networkUrl(videoUrl);
    _initializeVideoPlayerFuture = _controller
        .initialize()
        .then((_) => _controller.addListener(_videoListener));
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      CloseIcon(widget.onCloseButtonPressed),
                      const SizedBox(width: 12),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: snapshot.connectionState == ConnectionState.done
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 16,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: GestureDetector(
                                onTap: () => _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play(),
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                  ),
                ),
                InsightControls(controller: _controller),
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
