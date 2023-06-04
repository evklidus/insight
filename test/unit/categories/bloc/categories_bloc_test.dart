import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/categories/data/repositories/categories_repository.dart';
import 'package:insight/features/categories/domain/bloc/categories_bloc.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_bloc_test.mocks.dart';

class CategoryEntityFake extends Mock implements CategoryEntity {}

@GenerateMocks([CategoriesRepositoryImpl])
void main() {
  late CategoriesRepository categoriesRepository;
  final categories = [
    CategoryEntityFake(),
    CategoryEntityFake(),
    CategoryEntityFake(),
  ];

  setUp(() {
    categoriesRepository = MockCategoriesRepositoryImpl();
  });

  blocTest(
    'emits [CategoriesLoadedState] with [List<CategoryEntity>] when CategoriesEvent.get() is added',
    build: () => CategoriesBloc(categoriesRepository),
    setUp: () => when(categoriesRepository.getCategories()).thenAnswer(
      (_) async => categories,
    ),
    act: (bloc) => bloc.add(const CategoriesEvent.get()),
    expect: () => [
      isA<CategoriesLoadingState>(),
      CategoriesState.loaded(categories),
    ],
  );

  blocTest(
    'emits [CategoriesErrorState] when CategoriesEvent.get() is added',
    build: () => CategoriesBloc(categoriesRepository),
    setUp: () {
      when(categoriesRepository.getCategories()).thenAnswer(
        (_) => throw Exception(),
      );
    },
    act: (bloc) => bloc.add(const CategoriesEvent.get()),
    expect: () => [
      isA<CategoriesLoadingState>(),
      isA<CategoriesErrorState>(),
    ],
  );
}
