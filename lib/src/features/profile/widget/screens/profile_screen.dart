import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/features/profile/model/user_edit.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight/src/features/profile/bloc/profile_state.dart';
import 'package:insight/src/features/profile/widget/components/profile_information.dart';
import 'package:insight/src/features/profile/widget/components/profile_skeleton.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isEditing,
  });

  final bool isEditing;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _image;
  late bool _isEditing;

  late final ProfileBloc _profileBloc;
  late final TextEditingController _nameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;

    _profileBloc = context.read<ProfileBloc>();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
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

  void _save(String userId) {
    if (_isEditing) {
      final name = _nameController.text.trim();
      final lastName = _lastNameController.text.trim();

      final isEdited =
          (name != _profileBloc.state.data!.firstName && name.isNotEmpty) ||
              lastName != _profileBloc.state.data!.lastName ||
              _image != null;

      if (isEdited) {
        _profileBloc.add(
          ProfileEvent.edit(
            User$Edit(
              id: userId,
              firstName:
                  name.isNotEmpty ? name : _profileBloc.state.data!.firstName,
              lastName: lastName,
              avatarPath: _image?.path,
            ),
          ),
        );
      }

      setState(() => _isEditing = false);
    } else {
      setState(() => _isEditing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) => state.mapOrNull(
        error: (errorState) => InsightSnackBar.showError(
          context,
          text: errorState.message,
        ),
      ),
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            AppStrings.profile,
            action: GestureDetector(
              onTap: _profileBloc.state.data.isNotNull
                  ? () => _save(_profileBloc.state.data!.id)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: ShapeDecoration(
                  color: _isEditing
                      ? context.colorScheme.surfaceContainerHighest
                      : context.colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Сохранить' : 'Изменить',
                ),
              ),
            ),
          ),
          body: Builder(
            builder: (context) {
              if (!state.hasData && state.isProcessing) {
                return const ProfileSkeleton();
              } else if (!state.hasData && state.hasError) {
                return InformationWidget.error(
                  reloadFunc: () => _profileBloc.add(
                    const ProfileEvent.fetch(),
                  ),
                );
              } else if (!state.hasData) {
                return InformationWidget.empty(
                  reloadFunc: () => _profileBloc.add(
                    const ProfileEvent.fetch(),
                  ),
                );
              } else {
                return ProfileInformation(
                  user: state.data!,
                  isEditing: _isEditing,
                  image: _image,
                  addPhotoHandler: _addPhotoHandler,
                  nameController: _nameController,
                  lastNameController: _lastNameController,
                );
              }
            },
          ),
        );
      },
    );
  }
}
