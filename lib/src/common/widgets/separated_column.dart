import 'package:flutter/material.dart';

/// {@template separated_column}
/// SeparatedColumn widget.
/// {@endtemplate}
class SeparatedColumn extends StatelessWidget {
  /// {@macro separated_column}
  const SeparatedColumn({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: courses!
            .map(
              (course) => Padding(
                padding: EdgeInsets.only(
                    top: courses!.indexOf(course) == 0 ? 0 : 20),
                child: CourseWidget(
                  course: course,
                  categoryTag: categoryTag,
                ),
              ),
            )
            .toList(),
      );
}
