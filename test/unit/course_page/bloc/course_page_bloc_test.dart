import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';
import 'package:insight/features/course_page/domain/repositories/course_page_repository.dart';
import 'package:insight/features/course_page/presentation/bloc/course_page_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_page_bloc_test.mocks.dart';

class CoursePageEntityFake extends Mock implements CoursePageEntity {}

@GenerateMocks([CoursePageRepository])
void main() {
  late CoursePageRepository coursePageRepository;
  final coursePageEntity = CoursePageEntityFake();
  const coursePageId = 1;

  setUp(() {
    coursePageRepository = MockCoursePageRepository();
  });

  blocTest(
    'emits [CategoriesLoadedState] with [List<CategoryEntity>] when CategoriesEvent.get() is added',
    build: () => CoursePageBloc(coursePageRepository),
    setUp: () =>
        when(coursePageRepository.getCoursePage(coursePageId)).thenAnswer(
      (_) async => coursePageEntity,
    ),
    act: (bloc) => bloc.add(const CoursePageEvent.get(coursePageId)),
    expect: () => [
      isA<CoursePageState>(),
      CoursePageState.loaded(coursePageEntity),
    ],
  );

  blocTest(
    'emits [CategoriesErrorState] when CategoriesEvent.get() is added',
    build: () => CoursePageBloc(coursePageRepository),
    setUp: () {
      when(coursePageRepository.getCoursePage(coursePageId)).thenAnswer(
        (_) => throw Exception(),
      );
    },
    act: (bloc) => bloc.add(const CoursePageEvent.get(coursePageId)),
    expect: () => [
      isA<CoursePageState>(),
      isA<CoursePageState>(),
    ],
  );
}
