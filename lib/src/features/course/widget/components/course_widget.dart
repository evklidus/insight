import 'package:flutter/material.dart';
import 'package:insight/src/common/constants/app_strings.dart';
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
      trailing: statusBadge != null || isItsOwn
          ? _CourseTrailingBadges(
              statusBadge: statusBadge,
              isItsOwn: isItsOwn,
            )
          : null,
    );
  }
}

class _CourseTrailingBadges extends StatelessWidget {
  const _CourseTrailingBadges({
    required this.statusBadge,
    required this.isItsOwn,
  });

  final String? statusBadge;
  final bool isItsOwn;

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[
      if (statusBadge != null) _CoursePill(text: statusBadge!),
      if (isItsOwn) const _CoursePill(text: AppStrings.courseYoursBadge),
    ];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: badges.length == 1
          ? badges.single
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 6,
              children: badges,
            ),
    );
  }
}

class _CoursePill extends StatelessWidget {
  const _CoursePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: context.colorScheme.surfaceContainerHighest,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            text,
            style: context.textTheme.labelMedium,
          ),
        ),
      );
}
