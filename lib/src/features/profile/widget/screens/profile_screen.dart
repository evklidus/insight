import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight/src/features/profile/bloc/profile_state.dart';
import 'package:insight/src/features/profile/widget/components/profile_information.dart';
import 'package:insight/src/features/profile/widget/components/profile_skeleton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileBloc profileBloc;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    profileBloc =
        ProfileBloc(repository: DIContainer.instance.profileRepository)
          ..add(const ProfileEvent.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        AppStrings.profile,
        action: GestureDetector(
          onTap: () {
            // TODO: Реализовать сохранение
            setState(() => isEditing = !isEditing);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: ShapeDecoration(
              color: isEditing
                  ? context.colorScheme.surfaceContainerHighest
                  : context.colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              isEditing ? 'Сохранить' : 'Изменить',
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => profileBloc,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) => state.mapOrNull(
            error: (errorState) => InsightSnackBar.showError(
              context,
              text: errorState.message,
            ),
          ),
          builder: (context, state) {
            if (!state.hasData && state.isProcessing) {
              return const ProfileSkeleton();
            } else if (!state.hasData && state.hasError) {
              return InformationWidget.error(
                reloadFunc: () => profileBloc.add(
                  const ProfileEvent.fetch(),
                ),
              );
            } else if (!state.hasData) {
              return InformationWidget.empty(
                reloadFunc: () => profileBloc.add(
                  const ProfileEvent.fetch(),
                ),
              );
            } else {
              return ProfileInformation(
                user: state.data!,
                isEditing: isEditing,
              );
            }
          },
        ),
      ),
    );
  }
}
