import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/features/auth/bloc/auth_bloc.dart';
import 'package:insight/src/features/categories/bloc/categories_bloc.dart';
import 'package:insight/src/features/categories/bloc/categories_state.dart';
import 'package:insight/src/features/categories/widget/components/categories_list.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

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
    final authState = Provider.of<AuthBloc>(context).state;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () => authState.isAuthenticated ?? false
                ? context.pushNamed('create')
                : InsightSnackBar.showError(
                    context,
                    text: AppStrings.needAuthToCreateCourse,
                  ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => categoriesBloc,
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
          listener: (context, state) => state.mapOrNull(
            error: (errorState) =>
                InsightSnackBar.showError(context, text: errorState.message),
          ),
          builder: (context, state) {
            if (!state.hasData && state.hasError) {
              return InformationWidget.error(
                reloadFunc: () => categoriesBloc.add(
                  const CategoriesEvent.fetch(),
                ),
              );
            } else if (!state.hasData && !state.isProcessing) {
              return InformationWidget.empty(
                reloadFunc: () => categoriesBloc.add(
                  const CategoriesEvent.fetch(),
                ),
              );
            } else {
              return CategoriesList(categories: state.data);
            }
          },
        ),
      ),
    );
  }
}
