import 'package:flutter_test/flutter_test.dart';
import 'package:insight/core/http/rest_client.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/data/models/category_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_remote_datasource_test.mocks.dart';

class CategoryModelFake extends Fake implements CategoryModel {}

@GenerateMocks([RestClient])
void main() {
  late final CategoriesRemoteDataSourceImpl categoriesRemoteDataSource;
  final MockRestClient mockRestClient = MockRestClient();
  final categories = [
    CategoryModelFake(),
    CategoryModelFake(),
    CategoryModelFake(),
  ];

  setUpAll(() {
    categoriesRemoteDataSource = CategoriesRemoteDataSourceImpl(mockRestClient);
  });

  test(
      'get a Categories if mockRestClient.getCategories completes successfully',
      () {
    when(mockRestClient.getCategories()).thenAnswer((_) async => categories);
    expect(categoriesRemoteDataSource.getCategories(), completion(categories));
  });

  test(
      'throw an exception if mockRestClient.getCategories completes with error',
      () {
    when(mockRestClient.getCategories()).thenAnswer((_) => throw Exception());
    expect(categoriesRemoteDataSource.getCategories(), throwsException);
  });
}
