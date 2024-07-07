import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
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
  }) : sizeRadius = null;

  const FileWidget.rounded({
    required this.filePath,
    required this.type,
    this.sizeRadius = 100,
    super.key,
  });

  final String? filePath;
  final FileType type;

  final double? sizeRadius;

  bool get _isRounded => sizeRadius.isNotNull;

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
                      size: Size.fromRadius(sizeRadius!),
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
            : _isRounded
                ? FilePlaceholder.rounded(
                    type: type,
                    sizeRadius: sizeRadius,
                  )
                : FilePlaceholder(type: type),
      );
}
