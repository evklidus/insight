import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget(
    this.avatarUrl, {
    super.key,
    this.size,
  });

  final String? avatarUrl;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return avatarUrl != null
        ? CustomImageWidget(
            avatarUrl!,
            size: size,
            shape: BoxShape.circle,
          )
        : Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black45,
            ),
            width: size?.width,
            height: size?.height,
          );
  }
}
