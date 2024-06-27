import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/video_preview.dart';

enum FileType {
  image,
  video,
}

class FileWidget extends StatelessWidget {
  const FileWidget({
    required this.filePath,
    required this.type,
    super.key,
  })  : _isRounded = false,
        imageRadius = null;

  const FileWidget.rounded({
    required this.filePath,
    required this.type,
    this.imageRadius = 100,
    super.key,
  }) : _isRounded = true;

  final String? filePath;
  final FileType type;

  final bool _isRounded;
  final double? imageRadius;

  Widget _childFromFileType(FileType type) => switch (type) {
        FileType.image => Image.file(
            File(filePath!),
            fit: BoxFit.cover,
          ),
        FileType.video => VideoPreview(video: File(filePath!)),
      };

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: filePath != null
            ? _isRounded
                ? ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(imageRadius!),
                      child: _childFromFileType(type),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: _childFromFileType(type),
                    ),
                  )
            : _FilePlaceholder(
                type: type,
                isRounded: _isRounded,
                imageRadius: imageRadius,
              ),
      );
}

class _FilePlaceholder extends StatelessWidget {
  const _FilePlaceholder({
    required this.type,
    required this.isRounded,
    required this.imageRadius,
  });

  final FileType type;
  final bool isRounded;
  final double? imageRadius;

  @override
  Widget build(BuildContext context) => isRounded
      ? Container(
          width: imageRadius! * 2,
          height: imageRadius! * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.surfaceContainerLow,
          ),
          child: const Center(
            child: Icon(Icons.photo),
          ),
        )
      : AspectRatio(
          aspectRatio: 4 / 3,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: context.colorScheme.outline),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Center(
              child: Icon(Icons.photo),
            ),
          ),
        );
}
