import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/course_previews/data/course_previews_network_data_provider.dart';
import 'package:insight/src/features/course_previews/data/courses_preview_repository.dart';
import 'package:insight/src/features/course_previews/model/course_preview.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'courses_preview_repository_impl_test.mocks.dart';

@GenerateMocks([CoursePreviewsNetworkDataProvider])
void main() {
  late final CoursesPreviewRepositoryImpl coursesPreviewRepositoryImpl;
  late final mockCategoriesNetworkDataProvider =
      MockCoursePreviewsNetworkDataProvider();
  const categoryTag = 'sport';
  final coursePreviews = [
    CoursePreview(
      id: 1,
      name: 'name',
      imageUrl: 'imageUrl',
      tag: categoryTag,
    ),
  ];

  setUpAll(() {
    coursesPreviewRepositoryImpl = CoursesPreviewRepositoryImpl(
        networkDataProvider: mockCategoriesNetworkDataProvider);
  });

  test(
      'get a Categories if networkDataProvider.getCategories completes successfully',
      () {
    when(mockCategoriesNetworkDataProvider.getCoursePreviews(categoryTag))
        .thenAnswer((_) async => coursePreviews);
    expect(coursesPreviewRepositoryImpl.getCoursesPreview(categoryTag),
        isA<Future<List<CoursePreview>>>());
  });

  test(
      'throw an exception if networkDataProvider.getCategories completes with error',
      () {
    when(mockCategoriesNetworkDataProvider.getCoursePreviews(categoryTag))
        .thenAnswer((_) => throw Exception());
    expect(coursesPreviewRepositoryImpl.getCoursesPreview(categoryTag),
        throwsException);
  });
}
