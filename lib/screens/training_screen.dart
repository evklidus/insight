import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_sport/components/boxes.dart';
import 'package:m_sport/components/skeleton_loader.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              GestureDetector(
                onTap: context.router.pop,
                child: const Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: Colors.grey,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              WPaddingBox(
                child: Container(
                  height: 60.h,
                  child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        return AnimatedSwitcher(
                          switchInCurve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 800),
                          child: snapshot.connectionState == ConnectionState.done
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: AspectRatio(
                                      aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)))
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xff9F3953),
                                  ),
                                ),
                        );
                      }),
                ),
              ),
              const Spacer(
                flex: 3,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
                child: SizedBox(
                  height: 17.w,
                  width: 17.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      color: const Color(0xffFFEEEF),
                      child: _controller.value.isPlaying
                          ? const Icon(
                              CupertinoIcons.pause_fill,
                              color: Color(0xff9F3953),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(left: 3),
                              child: Icon(
                                CupertinoIcons.play_fill,
                                color: Color(0xff9F3953),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
