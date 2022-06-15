import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_sport/components/boxes.dart';
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
      body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            // if (snapshot.connectionState != ConnectionState.done) {
            //   return const Center(
            //     child: CircularProgressIndicator(
            //       color: Color(0xff9F3953),
            //     ),
            //   );
            // }
            return SafeArea(
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
                      child: SizedBox(
                        height: 60.h,
                        child: AnimatedSwitcher(
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
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                    PlayPauseButton(
                      snapshot.connectionState,
                      _controller.value.isPlaying,
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying ? _controller.pause() : _controller.play();
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
          }),
    );
  }
}

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton(
    this.connectionState,
    this.isPlaying, {
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final ConnectionState connectionState;
  final bool isPlaying;
  final Function() onTap;

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> with TickerProviderStateMixin {
  late final AnimationController _animationController;

  var isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.connectionState == ConnectionState.done
        ? const Color(0xffFFEEEF)
        : const Color.fromARGB(255, 239, 239, 239);
    final iconColor = widget.connectionState == ConnectionState.done
        ? const Color(0xff9F3953)
        : const Color.fromARGB(255, 185, 185, 185);
    final height = 17.w;
    const double radius = 20;

    return GestureDetector(
      onTap: () {
        if (widget.connectionState == ConnectionState.done) {
          widget.onTap();
          isAnimating = !isAnimating;
          isAnimating ? _animationController.forward() : _animationController.reverse();
        }
      },
      child: SizedBox(
        height: height,
        width: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(radius),
              color: backgroundColor,
              child: AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _animationController,
                color: iconColor,
              )),
        ),
      ),
    );
  }
}
