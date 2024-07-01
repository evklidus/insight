import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/adaptive_button.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/file/choice_file.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';

import 'package:insight/src/features/profile/model/user.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.nameController.text = widget.user.firstName;
    widget.lastNameController.text = widget.user.lastName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            AnimatedCrossFade(
              duration: standartDuration,
              crossFadeState:
                  widget.user.avatarUrl.isNotNull && widget.image.isNull
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              firstChild: CustomImageWidget(
                widget.user.avatarUrl!,
                size: Size.square(size.shortestSide * .64),
                shape: BoxShape.circle,
              ),
              secondChild: FileWidget.rounded(
                filePath: widget.image?.path,
                type: FileType.image,
                sizeRadius: size.shortestSide * .32,
              ),
            ),
            if (widget.isEditing)
              AdaptiveButton(
                onPressed: widget.addPhotoHandler,
                child: Text(
                  widget.image.isNotNull || widget.user.avatarUrl.isNotNull
                      ? AppStrings.changePhoto
                      : AppStrings.addPhoto,
                ),
              ),
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
                      hintText: 'Укажите имя',
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
                      hintText: 'Укажите фамилию',
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
              secondChild: Text(widget.user.fullName),
            ),
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
      ),
    );
  }
}
