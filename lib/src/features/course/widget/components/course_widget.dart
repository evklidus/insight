import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';
import 'package:insight/src/features/course/model/course.dart';

class CourseWidget extends StatelessWidget {
  const CourseWidget({
    super.key,
    required this.course,
    required this.categoryTag,
    this.userId,
    this.onTap,
    this.statusBadge,
  }) : _withCategory = false;

  const CourseWidget.withCategory({
    super.key,
    required this.course,
    required this.categoryTag,
    this.userId,
    this.onTap,
    this.statusBadge,
  }) : _withCategory = true;

  final Course course;
  final String categoryTag;
  final String? userId;
  final VoidCallback? onTap;
  final String? statusBadge;
  final bool _withCategory;

  @override
  Widget build(BuildContext context) {
    final isItsOwn = course.creatorId == userId;

    return InsightListTile(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      leadingSize: 60,
      leading: CustomImageWidget(
        resolveStorageUrl(course.imageUrl),
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        course.name,
        style: context.textTheme.titleMedium,
        maxLines: 2,
      ),
      subtitle: _withCategory ? Text(categoryTag) : null,
      trailing: _buildTrailing(context, isItsOwn),
    );
  }

  Widget? _buildTrailing(BuildContext context, bool isItsOwn) {
    final badges = <Widget>[];
    if (statusBadge != null) {
      badges.add(_badge(context, statusBadge!));
    }
    if (isItsOwn) {
      badges.add(_badge(context, 'Ваш'));
    }
    if (badges.isEmpty) return null;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: badges.length == 1
          ? badges.single
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: badges,
            ),
    );
  }

  Widget _badge(BuildContext context, String text) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: context.colorScheme.surfaceContainerHighest,
        ),
        child: Text(
          text,
          style: context.textTheme.labelLarge,
        ),
      );
}
