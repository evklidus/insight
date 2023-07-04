import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/course_previews/bloc/course_previews_bloc.dart';
import 'package:insight/features/course_previews/data/entities/course_preview_entity.dart';
import 'package:insight/features/course_previews/data/repositories/courses_preview_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_previews_bloc_test.mocks.dart';

class CoursePreviewEntityFake extends Mock implements CoursePreviewEntity {}

@GenerateMocks([CoursesPreviewRepository])
void main() {
  late CoursesPreviewRepository coursesPreviewRepository;
  final coursePreviews = [
    CoursePreviewEntityFake(),
    CoursePreviewEntityFake(),
    CoursePreviewEntityFake(),
  ];
  const categoryTag = 'sport';

  setUp(() {
    coursesPreviewRepository = MockCoursesPreviewRepository();
  });

  blocTest(
    'emits [CoursePreviewsLoadedState] with [List<CoursePreviewEntity>] when CoursePreviewsEvent.get() is added',
    build: () => CoursePreviewsBloc(coursesPreviewRepository),
    setUp: () => when(coursesPreviewRepository.getCoursesPreview(categoryTag))
        .thenAnswer(
      (_) async => coursePreviews,
    ),
    act: (bloc) => bloc.add(const CoursePreviewsEvent.get(categoryTag)),
    expect: () => [
      isA<CoursePreviewsLoadingState>(),
      CoursePreviewsState.loaded(coursePreviews),
    ],
  );

  blocTest(
    'emits [CoursePreviewsErrorState] when CoursePreviewsEvent.get() is added',
    build: () => CoursePreviewsBloc(coursesPreviewRepository),
    setUp: () {
      when(coursesPreviewRepository.getCoursesPreview(categoryTag)).thenAnswer(
        (_) => throw Exception(),
      );
    },
    act: (bloc) => bloc.add(const CoursePreviewsEvent.get(categoryTag)),
    expect: () => [
      isA<CoursePreviewsLoadingState>(),
      isA<CoursePreviewsErrorState>(),
    ],
  );
}
