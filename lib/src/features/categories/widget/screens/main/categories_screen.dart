import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/widgets/loadings/standart_loading.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/features/categories/bloc/categories_bloc.dart';
import 'package:insight/src/features/categories/widget/screens/states/categories_screen_loaded.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final categoriesBloc = CategoriesBloc(DIContainer().categoriesRepository);

  @override
  void initState() {
    super.initState();
    categoriesBloc.add(const CategoriesEvent.get());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        bloc: categoriesBloc,
        builder: (context, state) => state.when(
          idle: () => InformationWidget.empty(
            reloadFunc: () => categoriesBloc.add(
              const CategoriesEvent.get(),
            ),
          ),
          loading: () => const StandartLoading(),
          loaded: (categories) => CategoriesScreenLoaded(
            categories: categories,
          ),
          error: (errorMsg) => InformationWidget.error(
            description: errorMsg,
            reloadFunc: () => categoriesBloc.add(
              const CategoriesEvent.get(),
            ),
          ),
        ),
      ),
    );
  }
}
