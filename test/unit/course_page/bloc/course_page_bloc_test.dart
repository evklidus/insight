import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/course_page/bloc/course_page_state.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_page_bloc_test.mocks.dart';

@GenerateMocks([CoursePageRepository])
void main() {
  late CoursePageRepository coursePageRepository;
  const coursePageId = '1';
  const coursePage = CoursePage(
    id: coursePageId,
    imageUrl: 'imageUrl',
    lessons: [],
  );

  setUp(() {
    coursePageRepository = MockCoursePageRepository();
  });

  blocTest(
    'Successful with [List<Category>] on CategoriesEvent.fetch()',
    build: () => CoursePageBloc(repository: coursePageRepository),
    setUp: () =>
        when(coursePageRepository.getCoursePage(coursePageId)).thenAnswer(
      (_) async => coursePage,
    ),
    act: (bloc) => bloc.add(const CoursePageEvent.fetch(coursePageId)),
    expect: () => [
      isA<CoursePageState$Successful>(),
      const CoursePageState.successful(data: coursePage),
    ],
  );

  blocTest(
    'Error on CategoriesEvent.fetch()',
    build: () => CoursePageBloc(repository: coursePageRepository),
    setUp: () {
      when(coursePageRepository.getCoursePage(coursePageId)).thenAnswer(
        (_) => throw Exception(),
      );
    },
    act: (bloc) => bloc.add(const CoursePageEvent.fetch(coursePageId)),
    expect: () => [
      isA<CoursePageState$Error>(),
      isA<CoursePageState$Error>(),
    ],
  );
}
