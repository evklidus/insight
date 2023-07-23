import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/categories/data/categories_network_data_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/rest_client.dart';

import 'categories_remote_datasource_test.mocks.dart';

class CategoryDTOFake extends Fake implements CategoryDTO {}

@GenerateMocks([RestClient])
void main() {
  late final CategoriesNetworkDataProviderImpl categoriesNetworkDataProvider;
  final MockRestClient mockRestClient = MockRestClient();
  final categories = [
    CategoryDTOFake(),
    CategoryDTOFake(),
    CategoryDTOFake(),
  ];

  setUpAll(() {
    categoriesNetworkDataProvider =
        CategoriesNetworkDataProviderImpl(mockRestClient);
  });

  test(
      'get a Categories if mockRestClient.getCategories completes successfully',
      () {
    when(mockRestClient.getCategories()).thenAnswer((_) async => categories);
    expect(
        categoriesNetworkDataProvider.getCategories(), completion(categories));
  });

  test(
      'throw an exception if mockRestClient.getCategories completes with error',
      () {
    when(mockRestClient.getCategories()).thenAnswer((_) => throw Exception());
    expect(categoriesNetworkDataProvider.getCategories(), throwsException);
  });
}
