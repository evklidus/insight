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
  final exception = Exception();

  setUp(() {
    categoriesRepository = MockCategoriesRepository();
  });

  blocTest(
    'Successful on CategoriesEvent.fetch()',
    build: () => CategoriesBloc(repository: categoriesRepository),
    setUp: () => when(categoriesRepository.getCategories()).thenAnswer(
      (_) async => categories,
    ),
    act: (bloc) => bloc.add(const CategoriesEvent.fetch()),
    expect: () => [
      const CategoriesState.processing(data: null),
      const CategoriesState.successful(data: categories),
      const CategoriesState.idle(data: categories),
    ],
  );

  blocTest(
    'Error on CategoriesEvent.fetch()',
    build: () => CategoriesBloc(repository: categoriesRepository),
    setUp: () {
      when(categoriesRepository.getCategories()).thenThrow(exception);
    },
    act: (bloc) => bloc.add(const CategoriesEvent.fetch()),
    errors: () => [exception],
  );
}
