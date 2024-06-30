import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/adaptive_button.dart';
import 'package:insight/src/common/widgets/choice_file.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';

import 'package:insight/src/features/profile/model/user.dart';
import 'package:insight/src/features/profile/widget/components/avatar_widget.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({
    super.key,
    required this.user,
    required this.isEditing,
    required this.image,
    required this.addPhotoHandler,
    required this.nameController,
    required this.lastNameController,
  });

  final User user;
  final bool isEditing;
  final XFile? image;
  final VoidCallback addPhotoHandler;
  final TextEditingController nameController;
  final TextEditingController lastNameController;

  @override
  State<ProfileInformation> createState() => _ProfileLoadedScreenState();
}

class _ProfileLoadedScreenState extends State<ProfileInformation> {
  bool get _hasName => widget.user.firstName != null;

  @override
  void initState() {
    super.initState();
    widget.nameController.text = widget.user.firstName ?? '';
    widget.lastNameController.text = widget.user.lastName ?? '';
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
                  filePath: widget.image?.path,
                  type: FileType.image,
                ),
                AdaptiveButton(
                  onPressed: widget.addPhotoHandler,
                  child: Text(
                    widget.image == null
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
                      controller: widget.nameController,
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
                      controller: widget.lastNameController,
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
          AnimatedOpacity(
            opacity: widget.isEditing ? .4 : 1,
            duration: standartDuration,
            child: Text(
              widget.user.email,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
