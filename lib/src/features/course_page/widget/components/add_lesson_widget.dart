import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/adaptive_button.dart';
import 'package:insight/src/common/widgets/file/choice_file.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:permission_handler/permission_handler.dart';

/// {@template add_lesson_widget}
/// AddLessonWidget widget.
/// {@endtemplate}
class AddLessonWidget extends StatefulWidget {
  /// {@macro add_lesson_widget}
  const AddLessonWidget({
    required this.onAdd,
    super.key,
  });

  final Function(String name, String videoPath) onAdd;

  @override
  State<AddLessonWidget> createState() => _AddLessonWidgetState();
}

/// State for widget AddLessonWidget.
class _AddLessonWidgetState extends State<AddLessonWidget> {
  String _name = '';
  XFile? _video;

  Future<void> _addVideoHandler() async {
    final status = await Permission.photos.status;
    if (status.isDenied) {
      await Permission.photos.request();
      // TODO: Проверить не зацикливается ли
      _addVideoHandler();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isGranted) {
      final image = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      _video = image;
      setState(() => _video = image);
    }
  }

  void _addLessonHandler() {
    widget.onAdd(_name, _video!.path);
    context.pop();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FileWidget(
              filePath: _video?.path,
              type: FileType.video,
            ),
            AdaptiveButton(
              onPressed: _addVideoHandler,
              child: Text(
                _video == null ? AppStrings.addVideo : AppStrings.changeVideo,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              hintText: AppStrings.lessoneNameHint,
              onChanged: (value) => _name = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.pleaseEnterSomething;
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            AdaptiveButton.filled(
              onPressed: _addLessonHandler,
              child: const Text(AppStrings.add),
            ),
          ],
        ),
      );
}
