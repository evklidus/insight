import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/app_bars/insight_app_bar_with_back_button.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/widgets/loadings/standart_loading.dart';
import 'package:insight/src/core/sl/locator_service.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight/src/features/profile/widget/screens/states/profile_loaded_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileBloc profileBloc;
  @override
  void initState() {
    super.initState();
    profileBloc = getIt.get<ProfileBloc>()..add(const ProfileEvent.get());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InsightAppBarWithBackButton(AppStrings.profile),
      body: BlocProvider(
        create: (context) => profileBloc,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: profileBloc,
          builder: (context, state) => state.when(
            idle: () => InformationWidget.idle(),
            loading: () => const StandartLoading(),
            loaded: (user) => ProfileLoadedScreen(user: user),
            error: (errorMsg) => InformationWidget.error(
              description: errorMsg,
              reloadFunc: () => profileBloc.add(const ProfileEvent.get()),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    profileBloc.close();
    super.dispose();
  }
}
