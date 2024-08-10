import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';
import 'package:insight/src/common/widgets/modal_popup.dart';
import 'package:insight/src/common/widgets/text_fields/custom_text_field.dart';

import 'package:insight/src/features/profile/model/user.dart';
import 'package:insight/src/features/profile/widget/components/change_nickname.dart';

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
      child: SliverList.list(
        children: [
          const SizedBox(height: 24),
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
                ? Column(
                    children: [
                      CustomTextField(
                        type: InputType.firstName,
                        controller: widget.nameController,
                        hintText: 'Укажите имя',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        type: InputType.lastName,
                        controller: widget.lastNameController,
                        hintText: 'Укажите фамилию',
                      ),
                      const SizedBox(height: 32),
                      InsightListTile(
                        onTap: () => ModalPopup.show(
                          useRootNavigator: true,
                          context: context,
                          child: ChangeNickname(widget.user.username),
                        ),
                        title: Row(
                          children: [
                            Text(
                              'Имя пользователя',
                              style: context.textTheme.titleSmall,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.user.username.isNotNull
                                  ? widget.user.usernameWithDog
                                  : '',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : Text(
                    widget.user.fullName,
                    style: context.textTheme.titleLarge,
                  ),
          ),
          const SizedBox(height: 16),
          Center(
            child: AnimatedOpacity(
              opacity: widget.isEditing ? .4 : 1,
              duration: standartDuration,
              child: Text(
                widget.user.email +
                    (widget.isEditing || widget.user.username.isNull
                        ? ''
                        : ' • ${widget.user.usernameWithDog}'),
                style: context.textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
