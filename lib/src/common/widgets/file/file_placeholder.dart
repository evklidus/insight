import 'package:flutter/material.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/file/choice_file.dart';

class FilePlaceholder extends StatelessWidget {
  const FilePlaceholder({
    super.key,
    required this.type,
  })  : _isRounded = false,
        _sizeRadius = null;

  const FilePlaceholder.rounded({
    super.key,
    required this.type,
    double? sizeRadius,
  })  : _isRounded = true,
        _sizeRadius = sizeRadius;

  final FileType type;
  final bool _isRounded;
  final double? _sizeRadius;

  @override
  Widget build(BuildContext context) => _isRounded
      ? SizedBox.fromSize(
          size: _sizeRadius.isNotNull ? Size.fromRadius(_sizeRadius!) : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorScheme.surfaceContainerLow,
            ),
            child: const Center(
              child: Icon(Icons.photo),
            ),
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
