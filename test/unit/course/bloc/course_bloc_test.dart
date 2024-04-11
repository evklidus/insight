import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/course/bloc/course_bloc.dart';
import 'package:insight/src/features/course/bloc/course_state.dart';
import 'package:insight/src/features/course/model/course.dart';
import 'package:insight/src/features/course/data/course_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_bloc_test.mocks.dart';

@GenerateMocks([CourseRepository])
void main() {
  late CourseRepository coursesRepository;
  const categoryTag = 'sport';
  final courses = [
    const Course(
      id: '1',
      name: 'name',
      imageUrl: 'imageUrl',
      tag: categoryTag,
      isItsOwn: false,
    ),
  ];

  setUp(() {
    coursesRepository = MockCourseRepository();
  });

  blocTest(
    'emits [CourseLoadedState] with [List<Course>] when CourseEvent.get() is added',
    build: () => CourseBloc(repository: coursesRepository),
    setUp: () => when(coursesRepository.getCourse(categoryTag)).thenAnswer(
      (_) async => courses,
    ),
    act: (bloc) => bloc.add(const CourseEvent.fetch(categoryTag)),
    expect: () => [
      isA<CourseState$Successful>(),
      CourseState.successful(data: courses),
    ],
  );

  blocTest(
    'emits [CourseErrorState] when CourseEvent.get() is added',
    build: () => CourseBloc(repository: coursesRepository),
    setUp: () {
      when(coursesRepository.getCourse(categoryTag)).thenAnswer(
        (_) => throw Exception(),
      );
    },
    act: (bloc) => bloc.add(const CourseEvent.fetch(categoryTag)),
    expect: () => [
      isA<CourseState$Processing>(),
      isA<CourseState$Error>(),
    ],
  );
}
