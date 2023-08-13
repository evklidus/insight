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
    return categories.docs.map((doc) => _fromFirestoreToCategory(doc)).toList();
  }
}

Category _fromFirestoreToCategory(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  return Category(
    name: data!['name'],
    imageUrl: data['image_url'],
    tag: data['tag'],
  );
}
