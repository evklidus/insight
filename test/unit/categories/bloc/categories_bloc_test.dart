import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/categories/bloc/categories_state.dart';
import 'package:insight/src/features/categories/data/categories_repository.dart';
import 'package:insight/src/features/categories/bloc/categories_bloc.dart';
import 'package:insight/src/features/categories/model/category.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_bloc_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  late CategoriesRepository categoriesRepository;
  const categories = [
    Category(
      name: 'name',
      imageUrl: 'imageUrl',
      tag: 'tag',
    ),
  ];

  setUp(() {
    categoriesRepository = MockCategoriesRepository();
  });

  blocTest(
    'emits [CategoriesLoadedState] with [List<Category>] when CategoriesEvent.get() is added',
    build: () => CategoriesBloc(repository: categoriesRepository),
    setUp: () => when(categoriesRepository.getCategories()).thenAnswer(
      (_) async => categories,
    ),
    act: (bloc) => bloc.add(const CategoriesEvent.fetch()),
    expect: () => [
      isA<CategoriesState$Processing>(),
      const CategoriesState.successful(data: categories),
    ],
  );

  blocTest(
    'emits [CategoriesErrorState] when CategoriesEvent.get() is added',
    build: () => CategoriesBloc(repository: categoriesRepository),
    setUp: () {
      when(categoriesRepository.getCategories()).thenAnswer(
        (_) => throw Exception(),
      );
    },
    act: (bloc) => bloc.add(const CategoriesEvent.fetch()),
    expect: () => [
      isA<CategoriesState$Processing>(),
      isA<CategoriesState$Error>(),
    ],
  );
}
