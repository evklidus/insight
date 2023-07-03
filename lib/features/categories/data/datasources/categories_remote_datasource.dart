import 'package:rest_client/rest_client.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryDTO>> getCategories();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final RestClient client;

  CategoriesRemoteDataSourceImpl(this.client);

  @override
  Future<List<CategoryDTO>> getCategories() async {
    return await client.getCategories();
  }
}
