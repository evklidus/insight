import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/adaptive_button.dart';
import 'package:insight/src/common/widgets/choice_file.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';

import 'package:insight/src/features/profile/model/user.dart';
import 'package:insight/src/features/profile/widget/components/avatar_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({
    super.key,
    required this.user,
    required this.isEditing,
  });

  final User user;
  final bool isEditing;

  @override
  State<ProfileInformation> createState() => _ProfileLoadedScreenState();
}

class _ProfileLoadedScreenState extends State<ProfileInformation> {
  bool get _hasName => widget.user.firstName != null;

  XFile? _image;

  late final TextEditingController _nameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          AnimatedCrossFade(
            duration: standartDuration,
            crossFadeState: widget.isEditing
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                FileWidget.rounded(
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
              ],
            ),
            secondChild: AvatarWidget(
              widget.user.avatarUrl,
              size: const Size.square(200),
            ),
          ),
          if (_hasName) ...[
            const SizedBox(height: 20),
            AnimatedCrossFade(
              alignment: Alignment.center,
              duration: standartDuration,
              crossFadeState: widget.isEditing
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Имя',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _lastNameController,
                      hintText: 'Фамилия',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterSomething;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              secondChild: Text(
                '${widget.user.firstName} ${widget.user.lastName}',
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            widget.user.email,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
