import 'package:flutter/material.dart';
import 'package:insight/src/common/widgets/shimmer.dart';

/// {@template skeleton_list}
/// SkeletonList widget.
/// {@endtemplate}
class SkeletonList extends StatelessWidget {
  /// {@macro skeleton_list}
  const SkeletonList({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => const Shimmer(
          size: Size.fromHeight(100),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      );
}
