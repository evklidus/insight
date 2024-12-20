import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/common/widgets/insight_dismissible.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
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
    required this.editData,
  });

  final CoursePage coursePage;
  final VoidCallback? refreshCoursesList;
  final ({
    bool isEditing,
    XFile? image,
    VoidCallback addPhotoHandler,
    TextEditingController titleController,
    TextEditingController descriptionController,
  }) editData;

  @override
  State<CoursePageInfo> createState() => _CoursePageScreenLoadedState();
}

class _CoursePageScreenLoadedState extends State<CoursePageInfo> {
  @override
  void initState() {
    super.initState();
    widget.editData.titleController.text = widget.coursePage.name;
    widget.editData.descriptionController.text = widget.coursePage.description;
  }

  void _onDeletHandler(BuildContext ctx) {
    void deleteCourse() => Provider.of<CoursePageBloc>(ctx, listen: false).add(
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

    showAdaptiveDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Подтверждение'),
        content: const Text('Вы действительно хотитете удалить урок ?'),
        actions: [
          Platform.isIOS
              ? CupertinoDialogAction(
                  onPressed: deleteCourse,
                  child: const Text('Удалить'),
                )
              : TextButton(
                  onPressed: deleteCourse,
                  child: const Text('Удалить'),
                ),
          Platform.isIOS
              ? CupertinoDialogAction(
                  onPressed: context.pop,
                  isDefaultAction: true,
                  child: const Text('Отменить'),
                )
              : TextButton(
                  onPressed: context.pop,
                  child: const Text('Отменить'),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deleteCourseButtonStyle = TextStyle(color: context.colorScheme.error);

    final profileBloc = Provider.of<ProfileBloc>(context);
    final isItsOwn = widget.coursePage.creatorId == profileBloc.state.data?.id;

    return SliverList.list(
      children: [
        CustomImageWidget.editable(
          widget.coursePage.imageUrl,
          isEditing: widget.editData.isEditing,
          filePath: widget.editData.image?.path,
          onPressed: widget.editData.addPhotoHandler,
          borderRadius: BorderRadius.circular(28),
        ),
        AnimatedSwitcher(
          duration: standartDuration,
          child: widget.editData.isEditing
              ? Column(
                  children: [
                    CustomTextField(
                      controller: widget.editData.titleController,
                      hintText: 'Название',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: widget.editData.descriptionController,
                      hintText: 'Описание',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AdaptiveButton(
                      onPressed: () => _onDeletHandler(context),
                      child: Text(
                        AppStrings.delete,
                        style: deleteCourseButtonStyle,
                      ),
                    )
                  ],
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.coursePage.name,
                        style: context.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.coursePage.description,
                        style: context.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 20),
        if (widget.coursePage.lessons?.isNotEmpty ?? false)
          AbsorbPointer(
            absorbing: widget.editData.isEditing,
            child: AnimatedOpacity(
              duration: standartDuration,
              opacity: widget.editData.isEditing ? 0.4 : 1,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.coursePage.lessons!.length,
                itemBuilder: (context, index) {
                  final lesson = widget.coursePage.lessons![index];
                  return InsightDismissible(
                    isEnabled: isItsOwn,
                    itemKey: lesson,
                    deleteHandler: () =>
                        Provider.of<CoursePageBloc>(context, listen: false).add(
                      CoursePageEvent.removeLesson(
                        lesson: lesson,
                        onRemove: () {
                          InsightSnackBar.showSuccessful(
                            context,
                            text: 'Урок удален',
                          );
                        },
                      ),
                    ),
                    child: LessonWidget(lesson),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              ),
            ),
          )
        else
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: context.colorScheme.surfaceContainerLowest,
            ),
            child: const Text('Курс в разработке'),
          ),
      ],
    );
  }
}
