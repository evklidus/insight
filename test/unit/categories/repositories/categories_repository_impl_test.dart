import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/data/models/category_model.dart';
import 'package:insight/features/categories/data/repositories/categories_repository_impl.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_repository_impl_test.mocks.dart';

class CategoryModelFake extends Fake implements CategoryModel {}

class CategoryEntityFake extends Fake implements CategoryEntity {}

@GenerateMocks([CategoriesRemoteDataSource])
void main() {
  late final CategoriesRepositoryImpl categoriesRepositoryImpl;
  late final mockCategoriesRemoteDataSource = MockCategoriesRemoteDataSource();
  final models = [
    CategoryModelFake(),
    CategoryModelFake(),
    CategoryModelFake(),
  ];
  setUpAll(() {
    categoriesRepositoryImpl = CategoriesRepositoryImpl(
        remoteDataSource: mockCategoriesRemoteDataSource);
  });
  test(
      'get a Categories if remoteDataSource.getCategories completes successfully',
      () {
    when(mockCategoriesRemoteDataSource.getCategories())
        .thenAnswer((_) async => models);
    expect(categoriesRepositoryImpl.getCategories(),
        isA<Future<List<CategoryEntity>>>());
  });

  test(
      'throw an exception if remoteDataSource.getCategories completes with error',
      () {
    when(mockCategoriesRemoteDataSource.getCategories())
        .thenAnswer((_) => throw Exception());
    expect(categoriesRepositoryImpl.getCategories(), throwsException);
  });
}
