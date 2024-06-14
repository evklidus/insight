import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// {@template video_preview}
/// VideoPreview widget.
/// {@endtemplate}
class VideoPreview extends StatefulWidget {
  /// {@macro video_preview}
  const VideoPreview({
    required this.video,
    super.key,
  });

  final File video;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

/// State for widget VideoPreview.
class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          return AnimatedCrossFade(
            crossFadeState: snapshot.connectionState == ConnectionState.waiting
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.center,
            firstChild: Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            secondChild: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          );
        },
      );
}
