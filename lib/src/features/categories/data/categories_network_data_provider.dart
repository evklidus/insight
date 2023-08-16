import 'package:insight/src/features/categories/model/category.dart';
import 'package:rest_client/rest_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

final class CategoriesFirestoreDataProviderImpl
    implements CategoriesNetworkDataProvider {
  @override
  Future<List<Category>> getCategories() async {
    final firestore = FirebaseFirestore.instance;
    final categories = await firestore.collection('category').get();
    return categories.docs
        .map((doc) => _fromFirestoreToCategory(doc.id, doc.data()))
        .toList();
  }
}

Category _fromFirestoreToCategory(
  // TODO: Добавить id для категорий
  // ignore: avoid-unused-parameters
  String id,
  Map<String, dynamic>? categoryData,
) =>
    Category(
      name: categoryData!['name'],
      imageUrl: categoryData['image_url'],
      tag: categoryData['tag'],
    );
