import 'package:insight/src/features/categories/model/category.dart';
import 'package:rest_client/rest_client.dart';

abstract interface class CategoriesNetworkDataProvider {
  Future<List<Category>> getCategories();
}

final class CategoriesNetworkDataProviderImpl
    implements CategoriesNetworkDataProvider {
  const CategoriesNetworkDataProviderImpl(RestClient client) : _client = client;

  final RestClient _client;

  @override
  Future<List<Category>> getCategories() => _client
      .getCategories()
      .then((list) => list.map(Category.fromDTO).toList());
}
