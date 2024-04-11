import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/custom_snackbar.dart';
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
  // TDOD: При загружке доступных категорий снаяала выбранной будет первая
  Set<String> _selectedCategory = {'sport'};

  final formKey = GlobalKey<FormState>();

  late final CreateCourseBLoC _createCourseBloc;

  late final TextEditingController _nameController;
  late final TextEditingController _descrController;

  @override
  void initState() {
    super.initState();
    _createCourseBloc = CreateCourseBLoC(
      repository: DIContainer.instance.coursesRepository,
    );
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
    if (_image == null && !formKey.currentState!.validate()) {
      CustomSnackBar.showError(context, message: 'Добавьте фото');
    } else {
      _createCourseBloc.add(
        CreateCourseEvent.create(
          name: _nameController.text,
          description: _descrController.text,
          imagePath: _image!.path,
          categoryTag: _selectedCategory.first,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCourseBLoC, CreateCourseState>(
        listener: (context, state) => state.mapOrNull(
              successful: (state) {
                context.pop();
                CustomSnackBar.showSuccessful(context, message: state.message);
              },
              error: (state) =>
                  CustomSnackBar.showError(context, message: state.message),
            ),
        bloc: _createCourseBloc,
        builder: (context, state) {
          return WholeScreenLoadingIndicator(
            isLoading: state.isProcessing,
            child: Scaffold(
              appBar: const CustomAppBar('Создание курса'),
              body: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Добавлять уроки можно только после создания курса.',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              context.colorScheme.onBackground.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Text('Фото'),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: _image != null
                          ? _CourseImage(_image!.path)
                          : const _CourseImagePlaceholder(),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            onPressed: _addPhotoHandler,
                            child: Text(_image == null
                                ? 'Добавить фото'
                                : 'Изменить фото'),
                          )
                        : TextButton.icon(
                            icon: const Icon(Icons.add),
                            label: Text(_image == null
                                ? 'Добавить фото'
                                : 'Изменить фото'),
                            onPressed: _addPhotoHandler,
                          ),
                    const SizedBox(height: 16),
                    const Text('Название'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return value;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Описание'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _descrController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return value;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Категория'),
                    const SizedBox(height: 8),
                    // TODO: Получать категории с сервера
                    Platform.isIOS
                        ? CupertinoSegmentedControl<String>(
                            selectedColor: context.colorScheme.surface,
                            unselectedColor: Colors.transparent,
                            pressedColor: context.colorScheme.surface,
                            borderColor:
                                context.colorScheme.secondary.withOpacity(.25),
                            padding: const EdgeInsets.all(0),
                            groupValue: _selectedCategory.first,
                            onValueChanged: (value) => setState(
                              () => _selectedCategory
                                ..remove(_selectedCategory.first)
                                ..add(value),
                            ),
                            children: const {
                              'sport': _SegmentWidget('Спорт'),
                              'programming': _SegmentWidget('Программирование'),
                              'finance': _SegmentWidget('Финансы'),
                            },
                          )
                        : SegmentedButton<String>(
                            selected: _selectedCategory,
                            segments: const [
                              ButtonSegment(
                                value: 'sport',
                                label: _SegmentWidget('Спорт'),
                              ),
                              ButtonSegment(
                                value: 'programming',
                                label: _SegmentWidget('Программирование'),
                              ),
                              ButtonSegment(
                                value: 'finance',
                                label: _SegmentWidget('Финансы'),
                              ),
                            ],
                            onSelectionChanged: (value) => setState(
                              () => _selectedCategory = value,
                            ),
                          ),
                    const SizedBox(height: 32),
                    Platform.isIOS
                        ? CupertinoButton.filled(
                            onPressed: _createCourseHandler,
                            child: const Text('Создать'),
                          )
                        : FloatingActionButton.extended(
                            onPressed: _createCourseHandler,
                            label: const Text('Создать'),
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

class _CourseImage extends StatelessWidget {
  const _CourseImage(this.imagePath);

  final String imagePath;

  @override
  Widget build(BuildContext context) => ClipRRect(
        key: UniqueKey(),
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      );
}

class _CourseImagePlaceholder extends StatelessWidget {
  const _CourseImagePlaceholder();

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 4 / 3,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: context.colorScheme.surface),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Center(
            child: Text('Нет фото'),
          ),
        ),
      );
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
