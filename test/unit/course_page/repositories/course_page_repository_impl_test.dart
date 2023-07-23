import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/course_page/data/course_page_network_data_provider.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_page_repository_impl_test.mocks.dart';

@GenerateMocks([CoursePageNetworkDataProvider])
void main() {
  late final CoursePageRepositoryImpl coursePageRepositoryImpl;
  late final networkDataProvider = MockCoursePageNetworkDataProvider();
  const coursePageId = 1;
  const coursePage = CoursePage(
      id: coursePageId,
      imageUrl: 'imageUrl',
      lessons: [Lesson(name: 'name', videoUrl: 'videoUrl')]);

  setUpAll(() {
    coursePageRepositoryImpl = CoursePageRepositoryImpl(
      networkDataProvider: networkDataProvider,
    );
  });
  test(
      'get a Categories if networkDataProvider.getCategories completes successfully',
      () {
    when(networkDataProvider.getCoursePage(coursePageId)).thenAnswer(
      (_) async => coursePage,
    );
    expect(
      coursePageRepositoryImpl.getCoursePage(coursePageId),
      isA<Future<CoursePage>>(),
    );
  });

  test(
      'throw an exception if networkDataProvider.getCategories completes with error',
      () {
    when(networkDataProvider.getCoursePage(coursePageId)).thenAnswer(
      (_) => throw Exception(),
    );
    expect(
      coursePageRepositoryImpl.getCoursePage(coursePageId),
      throwsException,
    );
  });
}
