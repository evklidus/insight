import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_sliver_app_bar.dart';
import 'package:insight/src/common/widgets/buttons/cancel_button.dart';
import 'package:insight/src/common/widgets/buttons/edit_button.dart';
import 'package:insight/src/common/widgets/custom_android_refresh_indicator.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/features/profile/model/user_edit.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
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
      String name = _nameController.text.trim();
      final lastName = _lastNameController.text.trim();

      final isNameChanged =
          name != _profileBloc.state.data!.firstName && name.isNotEmpty;
      final isLastNameChanged = lastName != _profileBloc.state.data!.lastName;
      final isImageChanged = _image != null;

      final isEdited = isNameChanged || isLastNameChanged || isImageChanged;

      // Восстановление имени в контроллере в том случае, если его попытались убрать
      if (!isNameChanged) {
        name = _profileBloc.state.data!.firstName;
        _nameController.text = name;
      }

      if (isEdited) {
        _profileBloc.add(
          ProfileEvent.edit(
            User$Edit(
              id: userId,
              firstName: name,
              lastName: lastName,
            ),
          ),
        );
      }

      setState(() => _isEditing = false);
    } else {
      setState(() => _isEditing = true);
    }
  }

  Future<void> _onRefresh() async {
    final block = _profileBloc.stream.first;
    _profileBloc.add(const ProfileEvent.fetch());
    await block;
  }

  void _cancel() {
    final profile = _profileBloc.state.data!;
    _nameController.text = profile.firstName;
    if (profile.lastName.isNotNull) {
      _lastNameController.text = profile.lastName!;
    }
    _isEditing = false;
    setState(() {});
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
        return CustomAndroidRefreshIndicator(
          onRefresh: _onRefresh,
          child: AdaptiveScaffold(
            body: CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                  leading: _isEditing ? CancelButton(onPressed: _cancel) : null,
                  title: _isEditing
                      ? 'Редактирование'
                      : state.data?.username ?? AppStrings.profile,
                  previousPageTitle: AppStrings.settings,
                  action: EditButton(
                    isEditing: _isEditing,
                    opacity: _isEditing ? 1 : 0.8,
                    onPressed: _profileBloc.state.data.isNotNull
                        ? () => _save(_profileBloc.state.data!.id)
                        : null,
                  ),
                ),
                CupertinoSliverRefreshControl(onRefresh: _onRefresh),
                WidgetSwitcher.sliver(
                  state: (
                    hasData: state.hasData,
                    isProcessing: state.isProcessing,
                    hasError: state.hasError,
                  ),
                  refresh: _onRefresh,
                  skeletonBuilder: (context) =>
                      const SliverToBoxAdapter(child: ProfileSkeleton()),
                  childBuilder: (context) => ProfileInformation(
                    user: state.data!,
                    isEditing: _isEditing,
                    image: _image,
                    addPhotoHandler: _addPhotoHandler,
                    nameController: _nameController,
                    lastNameController: _lastNameController,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
