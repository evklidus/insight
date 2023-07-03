import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/course_previews/data/data_sources/course_previews_remote_data_source.dart';
import 'package:insight/features/course_previews/data/repositories/courses_preview_repository.dart';
import 'package:insight/features/course_previews/data/entities/course_preview_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/rest_client.dart';

import 'courses_preview_repository_impl_test.mocks.dart';

class CoursePreviewDTOFake extends Fake implements CoursePreviewDTO {
  @override
  int get id => 1;

  @override
  String get name => 'name';

  @override
  String get imageUrl => 'imageUrl';

  @override
  String get tag => 'tag';
}

@GenerateMocks([CoursePreviewsRemoteDataSource])
void main() {
  late final CoursesPreviewRepositoryImpl coursesPreviewRepositoryImpl;
  late final mockCategoriesRemoteDataSource =
      MockCoursePreviewsRemoteDataSource();
  final coursePreviews = [
    CoursePreviewDTOFake(),
    CoursePreviewDTOFake(),
    CoursePreviewDTOFake(),
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
