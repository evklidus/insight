import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';

import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/file/file_widget.dart';
import 'package:insight/src/common/widgets/modal_popup.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/features/course_page/widget/components/add_lesson_widget.dart';
import 'package:insight/src/common/widgets/insight_dismissible.dart';
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

  void _onAddLessonHandler(BuildContext ctx) => ModalPopup.show(
        context: context,
        child: AddLessonWidget(
          onAdd: (name, videoPath) =>
              Provider.of<CoursePageBloc>(context, listen: false).add(
            CoursePageEvent.addLesson(
              name: name,
              videoPath: videoPath,
              onAdd: () {
                InsightSnackBar.showSuccessful(
                  context,
                  text: 'Урок добавлен',
                );
              },
            ),
          ),
        ),
      );

  void _onDeletHandler(BuildContext ctx) =>
      Provider.of<CoursePageBloc>(ctx, listen: false).add(
        CoursePageEvent.delete(
          () {
            widget.refreshCoursesList?.call();
            InsightSnackBar.showSuccessful(
              context,
              text: AppStrings.courseDelete,
            );
            context.back();
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final deleteCourseButtonStyle = TextStyle(color: context.colorScheme.error);

    return Column(
      children: [
        AnimatedSwitcher(
          duration: standartDuration,
          child: widget.coursePage.imageUrl.isNotNull &&
                  widget.editData.image.isNull
              ? AspectRatio(
                  aspectRatio: 4 / 3,
                  child: CustomImageWidget(
                    widget.coursePage.imageUrl,
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
              : FileWidget(
                  filePath: widget.editData.image?.path,
                  type: FileType.image,
                ),
        ),
        AnimatedSwitcher(
          duration: standartDuration,
          child: widget.editData.isEditing
              ? Center(
                  child: AdaptiveButton(
                    onPressed: widget.editData.addPhotoHandler,
                    child: Text(
                      widget.editData.image.isNotNull ||
                              widget.coursePage.imageUrl.isNotNull
                          ? AppStrings.changePhoto
                          : AppStrings.addPhoto,
                    ),
                  ),
                )
              : const SizedBox(height: 20),
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
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.coursePage.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.coursePage.description,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
        ),
        if (widget.coursePage.isItsOwn && widget.editData.isEditing)
          Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                AdaptiveButton(
                  onPressed: () => _onAddLessonHandler(context),
                  child: const Text(AppStrings.addLesson),
                ),
                AdaptiveButton(
                  onPressed: () => _onDeletHandler(context),
                  child: Text(
                    AppStrings.delete,
                    style: deleteCourseButtonStyle,
                  ),
                )
              ],
            ),
          ),
        const SizedBox(height: 20),
        if (widget.coursePage.lessons?.isNotEmpty ?? false)
          IgnorePointer(
            ignoring: widget.editData.isEditing,
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
                    isEnabled: widget.coursePage.isItsOwn,
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
        const SizedBox(height: 20),
      ],
    );
  }
}
