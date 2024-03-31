import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
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
  @override
  void initState() {
    super.initState();
  }

  XFile? _image;
  // TDOD: При загружке доступных категорий снаяала выбранной будет первая
  Set<String> _selectedCategory = {'sport'};

  Future<void> _addPhotoHandler() async {
    final status = await Permission.photos.status;
    if (status.isDenied) {
      await Permission.photos.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isGranted) {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      _image = image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar('Создание курса'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // TODO: Превратиь это в более внятный вид (мб локальный онбординг)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Сначала необходимо создать курс, затем можно добавить уроки.\nПосле добавления первого урока можно разблокировать курс.',
              style: TextStyle(
                fontSize: 16,
                color: context.colorScheme.onBackground.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Text('Фото'),
          if (_image != null) Image.file(File(_image!.path)),
          Platform.isIOS
              ? CupertinoButton(
                  onPressed: _addPhotoHandler,
                  child:
                      Text(_image == null ? 'Добавить фото' : 'Изменить фото'),
                )
              : TextButton.icon(
                  icon: const Icon(Icons.add),
                  label:
                      Text(_image == null ? 'Добавить фото' : 'Изменить фото'),
                  onPressed: _addPhotoHandler,
                ),
          const SizedBox(height: 16),
          const Text('Название'),
          const CustomTextField(),
          const SizedBox(height: 16),
          const Text('Описание'),
          const CustomTextField(),
          const SizedBox(height: 16),
          const Text('Категория'),
          // Platform.isIOS
          //     ? CupertinoSegmentedControl<String>(
          //         children: {
          //           0: Text(AppLocalizations.of(context).tr('titles.secImg')),
          //           1: Text(AppLocalizations.of(context).tr('titles.secQuest')),
          //         },
          //         groupValue: _selectedIndexValue,
          //         onValueChanged: (value) {
          //           setState(() => _selectedIndexValue = value);
          //         },
          //       )
          //     :
          SegmentedButton<String>(
            selected: _selectedCategory,
            segments: const [
              ButtonSegment(
                value: 'sport',
                label: Text('Спорт'),
              ),
              ButtonSegment(
                value: 'programming',
                label: Text('Программирование'),
              ),
              ButtonSegment(
                value: 'finance',
                label: Text('Финансы'),
              ),
            ],
            onSelectionChanged: (value) =>
                setState(() => _selectedCategory = value),
          ),
          // const Text('Уроки'),
          // TextButton.icon(
          //   icon: const Icon(Icons.add),
          //   label: const Text('Добавить'),
          //   onPressed: () {
          //     ImagePicker()
          //         .pickVideo(source: ImageSource.gallery)
          //         .then((value) => null);
          //   },
          // ),
        ],
      ),
      floatingActionButton: Platform.isIOS
          ? CupertinoButton.filled(
              child: const Text('Создать'),
              onPressed: () {},
            )
          : FloatingActionButton.extended(
              onPressed: () {},
              label: const Text('Создать'),
            ),
    );
  }
}
