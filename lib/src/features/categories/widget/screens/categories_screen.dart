import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/widgets/custom_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/features/categories/bloc/categories_bloc.dart';
import 'package:insight/src/features/categories/bloc/categories_state.dart';
import 'package:insight/src/features/categories/widget/components/categories_list.dart';
import 'package:insight/src/features/categories/widget/components/gratitudes_skeleton.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late final CategoriesBloc categoriesBloc;

  @override
  void initState() {
    super.initState();
    categoriesBloc =
        CategoriesBloc(repository: DIContainer.instance.categoriesRepository)
          ..add(const CategoriesEvent.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      body: BlocProvider(
        create: (context) => categoriesBloc,
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
          listener: (context, state) => state.mapOrNull(
            error: (errorState) =>
                CustomSnackBar.showError(context, message: errorState.message),
          ),
          builder: (context, state) {
            if (!state.hasData && state.isProcessing) {
              return const GratitudesSkeleton();
            } else if (!state.hasData && state.hasError) {
              return InformationWidget.error(
                reloadFunc: () => categoriesBloc.add(
                  const CategoriesEvent.fetch(),
                ),
              );
            } else if (!state.hasData) {
              return InformationWidget.empty(
                reloadFunc: () => categoriesBloc.add(
                  const CategoriesEvent.fetch(),
                ),
              );
            } else {
              return CategoriesList(categories: state.data!);
            }
          },
        ),
      ),
    );
  }
}
