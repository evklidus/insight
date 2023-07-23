import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/categories/data/categories_network_data_provider.dart';
import 'package:insight/src/features/categories/data/categories_repository.dart';
import 'package:insight/src/features/categories/model/category.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_repository_impl_test.mocks.dart';

@GenerateMocks([CategoriesNetworkDataProvider])
void main() {
  late final CategoriesRepositoryImpl categoriesRepositoryImpl;
  late final mockCategoriesNetworkDataProvider =
      MockCategoriesNetworkDataProvider();
  const models = [
    Category(
      name: 'name',
      imageUrl: 'imageUrl',
      tag: 'tag',
    ),
  ];

  setUpAll(() {
    categoriesRepositoryImpl = CategoriesRepositoryImpl(
        networkDataProvider: mockCategoriesNetworkDataProvider);
  });
  test(
      'get a Categories if networkDataProvider.getCategories completes successfully',
      () {
    when(mockCategoriesNetworkDataProvider.getCategories())
        .thenAnswer((_) async => models);
    expect(categoriesRepositoryImpl.getCategories(),
        isA<Future<List<Category>>>());
  });

  test(
      'throw an exception if networkDataProvider.getCategories completes with error',
      () {
    when(mockCategoriesNetworkDataProvider.getCategories())
        .thenAnswer((_) => throw Exception());
    expect(categoriesRepositoryImpl.getCategories(), throwsException);
  });
}
