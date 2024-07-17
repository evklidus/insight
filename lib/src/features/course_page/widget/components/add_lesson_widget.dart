import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/file/file_widget.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
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

  final _formKey = GlobalKey<FormState>();

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

  void _addLessonHandler(BuildContext context) {
    if (_video.isNull) {
      return InsightSnackBar.showError(
        context,
        text: 'Добавьте видео',
      );
    } else if (_formKey.currentState!.validate() && _video.isNotNull) {
      widget.onAdd(_name, _video!.path);
      context.back();
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                onPressed: () => _addLessonHandler(context),
                child: const Text(AppStrings.add),
              ),
            ],
          ),
        ),
      );
}
