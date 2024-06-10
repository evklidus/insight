import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';

enum FileType {
  image,
  video,
}

class FileWidget extends StatelessWidget {
  const FileWidget({
    required this.filePath,
    required this.type,
    super.key,
  });

  final String? filePath;
  final FileType type;

  Widget _childFromFileType(FileType type) => switch (type) {
        FileType.image => Image.file(
            File(filePath!),
            fit: BoxFit.cover,
          ),
        FileType.video => const Placeholder(
            child: Center(
              child: Text('Видео добавлено'),
            ),
          ),
      };

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: filePath != null
            ? ClipRRect(
                key: UniqueKey(),
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: _childFromFileType(type),
                ),
              )
            : _FilePlaceholder(type),
      );
}

class _FilePlaceholder extends StatelessWidget {
  const _FilePlaceholder(this.type);

  final FileType type;

  String _getTitleFromType(FileType type) => switch (type) {
        FileType.image => 'Фото',
        FileType.video => 'Видео',
      };

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 4 / 3,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: context.colorScheme.surface),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: Text(_getTitleFromType(type)),
          ),
        ),
      );
}
