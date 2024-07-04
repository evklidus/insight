import 'package:dio/dio.dart';
import 'package:insight/src/features/categories/model/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class CategoriesNetworkDataProvider {
  Future<List<Category>> getCategories();
}

final class CategoriesNetworkDataProviderImpl
    implements CategoriesNetworkDataProvider {
  const CategoriesNetworkDataProviderImpl(Dio client) : _client = client;

  final Dio _client;

  @override
  Future<List<Category>> getCategories() async {
    final response = await _client.get('/categories');
    return (response.data as List<Map>).map(Category.fromJson).toList();
  }
}

final class CategoriesFirestoreDataProviderImpl
    implements CategoriesNetworkDataProvider {
  const CategoriesFirestoreDataProviderImpl(FirebaseFirestore firestore)
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<Category>> getCategories() async {
    final categoriesCollection = await _firestore.collection('category').get();
    final categories = categoriesCollection.docs
        .map((doc) => Category.fromFirestore(doc.id, doc.data()))
        .toList();
    return categories;
  }
}
