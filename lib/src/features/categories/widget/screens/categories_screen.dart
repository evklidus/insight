import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/features/auth/widget/auth_scope.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/features/categories/bloc/categories_bloc.dart';
import 'package:insight/src/features/categories/bloc/categories_state.dart';
import 'package:insight/src/features/categories/widget/components/categories_list.dart';

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
    final authScope = AuthScope.of(context);

    return AdaptiveScaffold(
      appBar: CustomAppBar(
        title: AppStrings.appName,
        action: IconButton(
          icon: Icon(
            isNeedCupertino
                ? CupertinoIcons.add_circled_solid
                : Icons.add_circle,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: () => authScope.isAuthenticated
              ? context.goRelativeNamed(RouteKeys.create.name)
              : InsightSnackBar.showError(
                  context,
                  text: AppStrings.needAuthToCreateCourse,
                ),
        ),
      ),
      body: BlocProvider(
        create: (context) => categoriesBloc,
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
          listener: (context, state) => state.mapOrNull(
            error: (errorState) =>
                InsightSnackBar.showError(context, text: errorState.message),
          ),
          builder: (context, state) => WidgetSwitcher(
            state: (
              hasData: state.hasData,
              isProcessing: state.isProcessing,
              hasError: state.hasError,
            ),
            refresh: () => categoriesBloc.add(const CategoriesEvent.fetch()),
            skeletonBuilder: (context) => const CategoriesListSkeleton(),
            childBuilder: (context) => CategoriesList(
              categories: state.data!,
            ),
          ),
        ),
      ),
    );
  }
}
