import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/course/data/course_network_data_provider.dart';
import 'package:insight/src/features/course/data/course_repository.dart';
import 'package:insight/src/features/course/model/course.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_repository_impl_test.mocks.dart';

@GenerateMocks([CourseNetworkDataProvider])
void main() {
  late final CourseRepositoryImpl coursesRepositoryImpl;
  late final mockCategoriesNetworkDataProvider =
      MockCourseNetworkDataProvider();
  const categoryTag = 'sport';
  final courses = [
    const Course(
      id: '1',
      name: 'name',
      imageUrl: 'imageUrl',
      tag: categoryTag,
      creatorId: '1',
    ),
  ];

  setUpAll(() {
    coursesRepositoryImpl = CourseRepositoryImpl(
        networkDataProvider: mockCategoriesNetworkDataProvider);
  });

  test(
      'get a Categories if networkDataProvider.getCategories completes successfully',
      () {
    when(mockCategoriesNetworkDataProvider.getCourse(categoryTag))
        .thenAnswer((_) async => courses);
    expect(coursesRepositoryImpl.getCourse(categoryTag),
        isA<Future<List<Course>>>());
  });

  test(
      'throw an exception if networkDataProvider.getCategories completes with error',
      () {
    when(mockCategoriesNetworkDataProvider.getCourse(categoryTag))
        .thenAnswer((_) => throw Exception());
    expect(coursesRepositoryImpl.getCourse(categoryTag), throwsException);
  });
}
