import 'package:flutter/material.dart';
import 'package:insight/features/program_page/presentation/widgets/close_icon.dart';
import 'package:insight/features/program_page/presentation/widgets/play_pause_button.dart';
import 'package:insight/features/program_page/presentation/widgets/training_video.dart';
import 'package:video_player/video_player.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
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
                  TrainingVideo(
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
