import 'package:flutter/material.dart';
import 'package:insight/core/builders/entity_builder.dart';
import 'package:insight/core/constants/string_constants.dart';
import 'package:insight/features/categories/presentation/screens/states/categories_screen_loaded.dart';
import 'package:insight/features/categories/presentation/stores/categories_store.dart';
import 'package:insight/services/di/locator_service.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final categoriesStore = getIt.get<CategoriesStore>();

  @override
  void initState() {
    categoriesStore.loadEntity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConstants.appName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Provider<CategoriesStore>(
        create: (context) => categoriesStore,
        builder: (context, _) {
          return const EntityBuilder<CategoriesStore>(
            loadedWidget: CategoriesScreenLoaded(),
          );
        },
      ),
    );
  }
}
