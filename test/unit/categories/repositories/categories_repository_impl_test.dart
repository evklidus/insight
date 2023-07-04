import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/data/repositories/categories_repository.dart';
import 'package:insight/features/categories/data/entities/category_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/rest_client.dart';

import 'categories_repository_impl_test.mocks.dart';

class CategoryDTOFake extends Fake implements CategoryDTO {
  @override
  String get name => 'name';

  @override
  String get imageUrl => 'imageUrl';

  @override
  String get tag => 'tag';
}

@GenerateMocks([CategoriesRemoteDataSource])
void main() {
  late final CategoriesRepositoryImpl categoriesRepositoryImpl;
  late final mockCategoriesRemoteDataSource = MockCategoriesRemoteDataSource();
  final models = [
    CategoryDTOFake(),
    CategoryDTOFake(),
    CategoryDTOFake(),
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
