import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/file/file_placeholder.dart';
import 'package:insight/src/common/widgets/video_preview.dart';

enum FileType {
  image,
  video,
}

class FileWidget extends StatelessWidget {
  const FileWidget({
    super.key,
    required this.filePath,
    required this.type,
    this.onPressed,
  })  : sizeRadius = null,
        isEditable = false;

  const FileWidget.rounded({
    super.key,
    required this.filePath,
    required this.type,
    this.sizeRadius = 100,
    this.onPressed,
  }) : isEditable = false;

  const FileWidget.editable({
    super.key,
    required this.filePath,
    required this.type,
    this.onPressed,
  })  : sizeRadius = null,
        isEditable = true;

  final String? filePath;
  final FileType type;
  final VoidCallback? onPressed;

  final double? sizeRadius;

  final bool isEditable;

  bool get _isRounded => sizeRadius.isNotNull;

  Widget _childFromFileType() => switch (type) {
        FileType.image => Image.file(
            File(filePath!),
            fit: BoxFit.cover,
          ),
        FileType.video => VideoPreview(video: File(filePath!)),
      };

  String _buttonTitleFromFileType() => switch (type) {
        FileType.image =>
          filePath.isNotNull ? AppStrings.changePhoto : AppStrings.addPhoto,
        FileType.video =>
          filePath.isNotNull ? AppStrings.changeVideo : AppStrings.addVideo,
      };

  @override
  Widget build(BuildContext context) {
    final placeholder = AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: filePath != null
          ? _isRounded
              ? ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(sizeRadius!),
                    child: _childFromFileType(),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _childFromFileType(),
                  ),
                )
          : _isRounded
              ? FilePlaceholder.rounded(
                  type: type,
                  sizeRadius: sizeRadius,
                )
              : FilePlaceholder(type: type),
    );

    if (!isEditable) {
      return placeholder;
    } else {
      final isHasVideo = filePath.isNotNull && type == FileType.video;
      return Column(
        children: [
          AdaptiveButton(
            padding: EdgeInsets.zero,
            onPressed: isHasVideo ? null : onPressed,
            child: placeholder,
          ),
          AnimatedSwitcher(
            duration: standartDuration,
            child: AdaptiveButton(
              onPressed: onPressed,
              child: Text(_buttonTitleFromFileType()),
            ),
          ),
        ],
      );
    }
  }
}
