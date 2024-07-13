import 'package:flutter/material.dart';

/// {@template separated_column}
/// SeparatedColumn widget.
/// {@endtemplate}
class SeparatedColumn extends StatelessWidget {
  /// {@macro separated_column}
  const SeparatedColumn({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.itemCount,
  });

  // final List list;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(
          itemCount,
          (index) => Column(
            children: [
              itemBuilder(context, index),
              if (index != itemCount - 1) separatorBuilder(context, index),
            ],
          ),
        ),
      );
}
