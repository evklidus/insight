import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/course_previews/data/data_sources/course_previews_remote_data_source.dart';
import 'package:insight/features/course_previews/data/models/course_preview_model.dart';
import 'package:insight/features/course_previews/data/repositories/courses_preview_repository.dart';
import 'package:insight/features/course_previews/domain/entities/course_preview_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'courses_preview_repository_impl_test.mocks.dart';

class CoursePreviewModelFake extends Fake implements CoursePreviewModel {}

@GenerateMocks([CoursePreviewsRemoteDataSource])
void main() {
  late final CoursesPreviewRepositoryImpl coursesPreviewRepositoryImpl;
  late final mockCategoriesRemoteDataSource =
      MockCoursePreviewsRemoteDataSource();
  final coursePreviews = [
    CoursePreviewModelFake(),
    CoursePreviewModelFake(),
    CoursePreviewModelFake(),
  ];
  const categoryTag = 'sport';

  setUpAll(() {
    coursesPreviewRepositoryImpl = CoursesPreviewRepositoryImpl(
        remoteDataSource: mockCategoriesRemoteDataSource);
  });

  test(
      'get a Categories if remoteDataSource.getCategories completes successfully',
      () {
    when(mockCategoriesRemoteDataSource.getCoursePreviews(categoryTag))
        .thenAnswer((_) async => coursePreviews);
    expect(coursesPreviewRepositoryImpl.getCoursesPreview(categoryTag),
        isA<Future<List<CoursePreviewEntity>>>());
  });

  test(
      'throw an exception if remoteDataSource.getCategories completes with error',
      () {
    when(mockCategoriesRemoteDataSource.getCoursePreviews(categoryTag))
        .thenAnswer((_) => throw Exception());
    expect(coursesPreviewRepositoryImpl.getCoursesPreview(categoryTag),
        throwsException);
  });
}
