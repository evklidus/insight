import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/buttons/edit_button.dart';
import 'package:insight/src/features/course_page/model/course_edit.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/src/features/course_page/bloc/course_page_state.dart';
import 'package:insight/src/features/course_page/widget/components/course_page_skeleton.dart';
import 'package:insight/src/features/course_page/widget/components/course_page_info.dart';
import 'package:permission_handler/permission_handler.dart';

class CoursePageScreen extends StatefulWidget {
  const CoursePageScreen({
    super.key,
    required this.coursePageId,
    this.refreshCoursesList,
  });

  final String coursePageId;
  final VoidCallback? refreshCoursesList;

  @override
  State<CoursePageScreen> createState() => _CoursePageScreenState();
}

class _CoursePageScreenState extends State<CoursePageScreen> {
  XFile? _image;
  bool _isEditing = false;

  late final CoursePageBloc _coursePageBloc;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _coursePageBloc = CoursePageBloc(
      repository: DIContainer.instance.coursePageRepository,
    )..add(CoursePageEvent.fetch(widget.coursePageId));

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  Future<void> _addPhotoHandler() async {
    final status = await Permission.photos.status;
    if (status.isDenied) {
      await Permission.photos.request();
      // TODO: Проверить не зацикливается ли
      _addPhotoHandler();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isGranted) {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      setState(() => _image = image);
    }
  }

  void _save(String userId) {
    if (_isEditing) {
      String title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      final isNameChanged =
          title != _coursePageBloc.state.data!.name && title.isNotEmpty;
      final isLastNameChanged =
          description != _coursePageBloc.state.data!.description;
      final isImageChanged = _image.isNotNull;

      final isEdited = isNameChanged || isLastNameChanged || isImageChanged;

      // Восстановление имени в контроллере в том случае, если его попытались убрать
      if (!isNameChanged) {
        title = _coursePageBloc.state.data!.name;
        _titleController.text = title;
      }

      if (isEdited) {
        _coursePageBloc.add(
          CoursePageEvent.editCourse(
            Course$Edit(
              id: userId,
              name: title,
              description: description,
              imagePath: _image?.path,
            ),
          ),
        );
      }

      setState(() => _isEditing = false);
    } else {
      setState(() => _isEditing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _coursePageBloc,
      child: BlocConsumer<CoursePageBloc, CoursePageState>(
        listener: (context, state) => state.mapOrNull(
          error: (errorState) =>
              InsightSnackBar.showError(context, text: errorState.message),
        ),
        builder: (context, state) {
          return AdaptiveScaffold(
            appBar: CustomAppBar(
              previousPageTitle: AppStrings.courses,
              action: EditButton(
                isEditing: _isEditing,
                opacity:
                    state.data?.isItsOwn ?? false ? (_isEditing ? 1 : 0.8) : 0,
                onPressed: state.data?.isItsOwn ?? false
                    ? (_coursePageBloc.state.data.isNotNull
                        ? () => _save(_coursePageBloc.state.data!.id)
                        : null)
                    : null,
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Builder(
                    builder: (context) {
                      if (!state.hasData && state.isProcessing) {
                        return const CoursePageSkeleton();
                      } else if (!state.hasData && state.hasError) {
                        return InformationWidget.error(
                          reloadFunc: () => _coursePageBloc.add(
                            CoursePageEvent.fetch(widget.coursePageId),
                          ),
                        );
                      } else if (!state.hasData) {
                        return InformationWidget.empty(
                          reloadFunc: () => _coursePageBloc.add(
                            CoursePageEvent.fetch(widget.coursePageId),
                          ),
                        );
                      } else {
                        return CoursePageInfo(
                          coursePage: state.data!,
                          refreshCoursesList: widget.refreshCoursesList,
                          editData: (
                            isEditing: _isEditing,
                            titleController: _titleController,
                            descriptionController: _descriptionController,
                            image: _image,
                            addPhotoHandler: _addPhotoHandler,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
