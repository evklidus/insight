import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:insight_player/insight_player.dart';

@RoutePage()
class InsightPlayerScreen extends StatelessWidget {
  const InsightPlayerScreen({
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
  Widget build(BuildContext context) => InsightPlayer(
        videoUrl: videoUrl,
        title: title,
        onVideoEnd: onVideoEnd,
        onCloseButtonPressed: onCloseButtonPressed,
      );
}
