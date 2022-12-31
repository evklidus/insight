import 'package:insight/features/categories/data/models/category_model.dart';
import 'package:insight/services/http/rest_client.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>?> getCategories();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final RestClient client;

  CategoriesRemoteDataSourceImpl(this.client);

  @override
  Future<List<CategoryModel>?> getCategories() async {
    final categories = await client.getCategories();
    return categories;
  }
}
