import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
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

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              CustomImageWidget.editable(
                widget.user.avatarUrl!,
                size: Size.square(size.shortestSide * .64),
                shape: BoxShape.circle,
                isEditing: widget.isEditing,
                filePath: widget.image?.path,
                onPressed: widget.addPhotoHandler,
                placeholderSizeRadius: size.shortestSide * .32,
              ),
              AnimatedSwitcher(
                duration: standartDuration,
                child: widget.isEditing
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CustomTextField(
                              type: InputType.firstName,
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
                              type: InputType.lastName,
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
                      )
                    : Text(
                        widget.user.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
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
      ),
    );
  }
}
