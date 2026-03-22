import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/core/player/insight_player.dart';
import 'package:insight/src/features/learning/bloc/learning_bloc.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    this.courseId,
    this.lessonId,
  });

  final String videoUrl;
  final String title;
  final String? courseId;
  final String? lessonId;

  @override
  Widget build(BuildContext context) {
    return InsightPlayer(
      videoUrl: videoUrl,
      title: title,
      onVideoEnd: () => _onVideoEnd(context),
      onCloseButtonPressed: () => context.pop(),
    );
  }

  void _onVideoEnd(BuildContext context) {
    if (courseId != null && lessonId != null && lessonId!.isNotEmpty) {
      context.read<LearningBloc>().add(
            LearningEvent.completeLesson(
              courseId: courseId!,
              lessonId: lessonId!,
            ),
          );
    }
    context.pop();
  }
}
