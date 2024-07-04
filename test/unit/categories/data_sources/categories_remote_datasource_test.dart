// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:insight/src/features/categories/data/categories_network_data_provider.dart';
// import 'package:insight/src/features/categories/model/category.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'categories_remote_datasource_test.mocks.dart';

// class CategoryFake extends Fake implements Category {}

// @GenerateMocks([Dio])
// void main() {
//   late final CategoriesNetworkDataProviderImpl categoriesNetworkDataProvider;
//   final mockRestClient = MockDio();
//   final categories = [
//     CategoryFake(),
//     CategoryFake(),
//     CategoryFake(),
//   ];

//   setUpAll(() {
//     categoriesNetworkDataProvider =
//         CategoriesNetworkDataProviderImpl(mockRestClient);
//   });

//   test(
//       'get a Categories if mockRestClient.getCategories completes successfully',
//       () {
//     when(mockRestClient.getCategories()).thenAnswer((_) async => categories);
//     expect(
//         categoriesNetworkDataProvider.getCategories(), completion(categories));
//   });

//   test(
//       'throw an exception if mockRestClient.getCategories completes with error',
//       () {
//     when(mockRestClient.getCategories()).thenAnswer((_) => throw Exception());
//     expect(categoriesNetworkDataProvider.getCategories(), throwsException);
//   });
// }
