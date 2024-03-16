import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar('Создание курса'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const Text('Фото'),
          if (_image != null) Image.file(File(_image!.path)),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(_image == null ? 'Добавить фото' : 'Изменить фото'),
            onPressed: () async {
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
            },
          ),
          const Text('Название'),
          const CustomTextField(),
          const Text('Описание'),
          const CustomTextField(),
          const Text('Уроки'),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
            onPressed: () {
              ImagePicker()
                  .pickVideo(source: ImageSource.gallery)
                  .then((value) => null);
            },
          ),
        ],
      ),
    );
  }
}
