import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/common/di/locator_service.dart';
import 'package:insight/common/widgets/information_widget.dart';
import 'package:insight/common/widgets/loadings/standart_loading.dart';
import 'package:insight/common/constants/app_strings.dart';
import 'package:insight/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:insight/features/categories/presentation/screens/states/categories_screen_loaded.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final categoriesBloc = getIt.get<CategoriesBloc>();

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
          idle: () => InformationWidget.idle(),
          loading: () => const StandartLoading(),
          loaded: (categories) => CategoriesScreenLoaded(
            categories: categories,
          ),
          error: () => InformationWidget.error(),
        ),
      ),
    );
  }
}
