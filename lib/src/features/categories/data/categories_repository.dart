import 'package:insight/src/features/categories/data/categories_network_data_provider.dart';
import 'package:insight/src/features/categories/model/category.dart';

abstract interface class CategoriesRepository {
  Future<List<Category>> getCategories();
}

final class CategoriesRepositoryImpl implements CategoriesRepository {
  const CategoriesRepositoryImpl({
    required CategoriesNetworkDataProvider networkDataProvider,
  }) : _networkDataProvider = networkDataProvider;

  final CategoriesNetworkDataProvider _networkDataProvider;

  @override
  Future<List<Category>> getCategories() =>
      _networkDataProvider.getCategories();
}
