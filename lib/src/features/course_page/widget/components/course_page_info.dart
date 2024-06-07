import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';

import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:insight/src/features/course_page/widget/components/lesson_widget.dart';
import 'package:provider/provider.dart';

class CoursePageInfo extends StatefulWidget {
  const CoursePageInfo({
    super.key,
    required this.coursePage,
    this.refreshCoursesList,
  });

  final CoursePage coursePage;
  final VoidCallback? refreshCoursesList;

  @override
  State<CoursePageInfo> createState() => _CoursePageScreenLoadedState();
}

class _CoursePageScreenLoadedState extends State<CoursePageInfo> {
  void _onDeletHandler(BuildContext ctx) =>
      Provider.of<CoursePageBloc>(ctx, listen: false).add(
        CoursePageEvent.delete(
          () {
            widget.refreshCoursesList?.call();
            InsightSnackBar.showSuccessful(
              context,
              text: AppStrings.courseDelete,
            );
            context.pop();
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final deleteCourseButtonStyle = TextStyle(color: context.colorScheme.error);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomImageWidget(
              widget.coursePage.imageUrl,
              height: 190,
              width: double.infinity,
              borderRadius: BorderRadius.circular(30),
            ),
            const SizedBox(height: 20),
            Text(
              widget.coursePage.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 15),
            Text(
              widget.coursePage.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            if (widget.coursePage.lessons?.isNotEmpty ?? false)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.coursePage.lessons!.length,
                itemBuilder: (context, index) =>
                    LessonWidget(widget.coursePage.lessons![index]),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              )
            else
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: context.colorScheme.surface,
                ),
                child: const Text('Курс в разаработке'),
              ),
            const SizedBox(height: 20),
            if (widget.coursePage.isItsOwn)
              Align(
                alignment: Alignment.center,
                child: Platform.isIOS
                    ? CupertinoButton(
                        onPressed: () => _onDeletHandler(context),
                        child: Text(
                          AppStrings.delete,
                          style: deleteCourseButtonStyle,
                        ),
                      )
                    : TextButton(
                        onPressed: () => _onDeletHandler(context),
                        child: Text(
                          AppStrings.delete,
                          style: deleteCourseButtonStyle,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
