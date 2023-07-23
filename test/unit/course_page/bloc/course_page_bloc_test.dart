import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_page_bloc_test.mocks.dart';

@GenerateMocks([CoursePageRepository])
void main() {
  late CoursePageRepository coursePageRepository;
  const coursePageId = 1;
  const coursePage = CoursePage(
    id: coursePageId,
    imageUrl: 'imageUrl',
    lessons: [],
  );

  setUp(() {
    coursePageRepository = MockCoursePageRepository();
  });

  blocTest(
    'emits [CategoriesLoadedState] with [List<Category>] when CategoriesEvent.get() is added',
    build: () => CoursePageBloc(coursePageRepository),
    setUp: () =>
        when(coursePageRepository.getCoursePage(coursePageId)).thenAnswer(
      (_) async => coursePage,
    ),
    act: (bloc) => bloc.add(const CoursePageEvent.get(coursePageId)),
    expect: () => [
      isA<CoursePageState>(),
      const CoursePageState.loaded(coursePage),
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
