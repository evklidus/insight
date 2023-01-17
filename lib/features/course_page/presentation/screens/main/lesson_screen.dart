import 'package:flutter/material.dart';
import 'package:insight/features/course_page/presentation/widgets/close_icon.dart';
import 'package:insight/features/course_page/presentation/widgets/lesson_video.dart';
import 'package:insight/features/course_page/presentation/widgets/play_pause_button.dart';
import 'package:video_player/video_player.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  const CloseIcon(),
                  const Spacer(
                    flex: 1,
                  ),
                  LessonVideo(
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
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
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
