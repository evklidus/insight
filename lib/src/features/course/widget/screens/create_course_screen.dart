import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/adaptive_button.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/file/file_widget.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight/src/common/widgets/whole_screen_loading_indicator.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/course/bloc/create_course/create_course_bloc.dart';
import 'package:insight/src/features/course/bloc/create_course/create_course_event.dart';
import 'package:insight/src/features/course/bloc/create_course/create_course_state.dart';
import 'package:permission_handler/permission_handler.dart';

/// {@template create_course_screen}
/// CreateCourseScreen widget.
/// {@endtemplate}
class CreateCourseScreen extends StatefulWidget {
  /// {@macro create_course_screen}
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

/// State for widget CreateCourseScreen.
class _CreateCourseScreenState extends State<CreateCourseScreen> {
  XFile? _image;
  Set<String> _selectedCategory = {};

  final _formKey = GlobalKey<FormState>();

  late final CreateCourseBLoC _createCourseBloc;

  late final TextEditingController _nameController;
  late final TextEditingController _descrController;

  @override
  void initState() {
    super.initState();
    _createCourseBloc = CreateCourseBLoC(
      repository: DIContainer.instance.coursesRepository,
    )..add(const CreateCourseEvent.fetchTags());
    _nameController = TextEditingController();
    _descrController = TextEditingController();
  }

  @override
  void dispose() {
    _createCourseBloc.close();
    _nameController.dispose();
    _descrController.dispose();
    super.dispose();
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

  void _createCourseHandler() {
    final isValid = _formKey.currentState!.validate();
    if (_image == null) {
      return InsightSnackBar.showError(
        context,
        text: AppStrings.addPhotoMessage,
      );
    } else if (_image != null && isValid) {
      _createCourseBloc.add(
        CreateCourseEvent.create(
          name: _nameController.text,
          description: _descrController.text,
          imagePath: _image!.path,
          categoryTag: _selectedCategory.first,
          onCreateCallback: () {
            context.pop();
            InsightSnackBar.showSuccessful(
              context,
              text: AppStrings.courseSuccessfullyCreated,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCourseBLoC, CreateCourseState>(
        listener: (context, state) => state.mapOrNull(
              successful: (state) => _selectedCategory.isEmpty && state.hasTags
                  ? _selectedCategory.add(state.tags!.first.categoryTag)
                  : null,
              error: (state) =>
                  InsightSnackBar.showError(context, text: state.message),
            ),
        bloc: _createCourseBloc,
        builder: (context, state) {
          return WholeScreenLoadingIndicator(
            isLoading: state.isProcessing,
            child: Scaffold(
              appBar: const CustomAppBar(title: AppStrings.courseCreation),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        AppStrings.addLessonsAfterCreatingCourse,
                        style: TextStyle(
                          fontSize: 16,
                          color: context.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Text(AppStrings.photo),
                    const SizedBox(height: 8),
                    FileWidget(
                      filePath: _image?.path,
                      type: FileType.image,
                    ),
                    AdaptiveButton(
                      onPressed: _addPhotoHandler,
                      child: Text(
                        _image == null
                            ? AppStrings.addPhoto
                            : AppStrings.changePhoto,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(AppStrings.title),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _nameController,
                      hintText: AppStrings.courseNameHint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(AppStrings.description),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _descrController,
                      hintText: AppStrings.courseDescrHint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(AppStrings.category),
                    const SizedBox(height: 8),
                    if (state.hasTags && _selectedCategory.first.isNotEmpty)
                      Platform.isIOS
                          ? CupertinoSegmentedControl<String>(
                              selectedColor:
                                  context.colorScheme.surfaceContainerHighest,
                              unselectedColor:
                                  context.colorScheme.surfaceContainerLow,
                              pressedColor:
                                  context.colorScheme.surfaceContainerHigh,
                              borderColor:
                                  context.colorScheme.outline.withOpacity(.25),
                              padding: const EdgeInsets.all(0),
                              groupValue: _selectedCategory.first,
                              onValueChanged: (value) => setState(
                                () => _selectedCategory
                                  ..remove(_selectedCategory.first)
                                  ..add(value),
                              ),
                              children: state.tags!.asMap().map(
                                    (key, tag) => MapEntry(
                                      tag.categoryTag,
                                      _SegmentWidget(tag.categoryName),
                                    ),
                                  ),
                            )
                          : SegmentedButton<String>(
                              selected: _selectedCategory,
                              segments: state.tags!
                                  .map(
                                    (tag) => ButtonSegment(
                                      value: tag.categoryTag,
                                      label: _SegmentWidget(tag.categoryName),
                                    ),
                                  )
                                  .toList(),
                              onSelectionChanged: (value) => setState(
                                () => _selectedCategory = value,
                              ),
                            ),
                    const SizedBox(height: 32),
                    Platform.isIOS
                        ? CupertinoButton.filled(
                            onPressed: _createCourseHandler,
                            child: const Text(AppStrings.create),
                          )
                        : FloatingActionButton.extended(
                            onPressed: _createCourseHandler,
                            label: const Text(AppStrings.create),
                          ),
                    SizedBox(height: MediaQuery.viewPaddingOf(context).bottom),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _SegmentWidget extends StatelessWidget {
  const _SegmentWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          text,
          style: context.textTheme.labelLarge,
        ),
      );
}
