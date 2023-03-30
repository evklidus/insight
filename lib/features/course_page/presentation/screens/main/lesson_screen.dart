import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insight/components/boxes/w_box.dart';
import 'package:insight/features/course_page/presentation/widgets/close_icon.dart';
import 'package:insight/features/course_page/presentation/widgets/lesson_video.dart';
import 'package:insight/features/course_page/presentation/widgets/play_pause_button.dart';
import 'package:video_player/video_player.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    Key? key,
    required this.videoUrl,
    required this.title,
  }) : super(key: key);

  final String videoUrl;
  final String title;

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
    _initializeVideoPlayerFuture = _controller.initialize().then(
          (value) => _controller.addListener(
            () {
              final bool isEndOfVideo =
                  _controller.value.position >= _controller.value.duration;

              if (isEndOfVideo) {
                context.router.pop();
              }
            },
          ),
        );
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 15.h,
                    ),
                    child: Row(
                      children: [
                        const CloseIcon(),
                        WBox(10.w),
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
