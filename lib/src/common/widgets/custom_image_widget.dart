import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/file/file_widget.dart';

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget(
    String this.imageUrl, {
    super.key,
    this.size,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
  })  : isEditing = false,
        filePath = null,
        onPressed = null,
        isEditable = false,
        placeholderSizeRadius = null;

  const CustomImageWidget.editable(
    this.imageUrl, {
    super.key,
    this.size,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    required this.isEditing,
    required this.filePath,
    required this.onPressed,
    this.placeholderSizeRadius = 100,
  }) : isEditable = true;

  final String? imageUrl;
  final Size? size;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final BoxFit fit;

  final bool isEditable;
  final bool isEditing;
  final String? filePath;
  final double? placeholderSizeRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      width: size?.width,
      height: size?.height,
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => Container(
        width: size?.width,
        height: size?.height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          shape: shape,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
    );
    if (!isEditable) {
      return image;
    } else {
      return Column(
        children: [
          AdaptiveButton(
            padding: EdgeInsets.zero,
            onPressed: isEditing ? onPressed : null,
            child: AnimatedSwitcher(
              duration: standartDuration,
              child: isEditing && (filePath.isNotNull || imageUrl.isNull)
                  ? shape == BoxShape.circle
                      ? FileWidget.rounded(
                          filePath: filePath,
                          type: FileType.image,
                          sizeRadius: placeholderSizeRadius,
                        )
                      : FileWidget(
                          filePath: filePath,
                          type: FileType.image,
                        )
                  : AspectRatio(aspectRatio: 4 / 3, child: image),
            ),
          ),
          AnimatedSwitcher(
            duration: standartDuration,
            child: isEditing
                ? AdaptiveButton(
                    padding: const EdgeInsets.all(24),
                    onPressed: onPressed,
                    child: Text(
                      filePath.isNotNull || imageUrl.isNotNull
                          ? AppStrings.changePhoto
                          : AppStrings.addPhoto,
                    ),
                  )
                : const SizedBox(height: 20),
          ),
        ],
      );
    }
  }
}
