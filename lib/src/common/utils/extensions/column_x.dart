import 'package:flutter/material.dart';

extension ColumnX on Column {
  Widget get separated => this
      .children
      .map(
        (course) => Padding(
          padding: EdgeInsets.only(top: courses!.indexOf(course) == 0 ? 0 : 20),
          child: CourseWidget(
            course: course,
            categoryTag: categoryTag,
          ),
        ),
      )
      .toList();
}
