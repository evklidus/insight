import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/insight_image_widget.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget(
    this.avatarUrl, {
    super.key,
    required this.width,
    required this.height,
  });

  final String? avatarUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return avatarUrl != null
        ? InsightImageWidget(
            avatarUrl!,
            width: width,
            height: height,
            shape: BoxShape.circle,
          )
        : Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black45,
            ),
            width: width,
            height: height,
          );
  }
}
