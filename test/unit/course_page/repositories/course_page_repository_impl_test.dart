import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/course_page/data/data_sources/course_page_remote_data_source.dart';
import 'package:insight/features/course_page/data/models/course_page_model.dart';
import 'package:insight/features/course_page/data/repositories/course_page_repository_impl.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_page_repository_impl_test.mocks.dart';

class CoursePageModelFake extends Fake implements CoursePageModel {}

@GenerateMocks([CoursePageRemoteDataSource])
void main() {
  late final CoursePageRepositoryImpl coursePageRepositoryImpl;
  late final remoteDataSource = MockCoursePageRemoteDataSource();
  final coursePageModel = CoursePageModelFake();
  const coursePageId = 1;

  setUpAll(() {
    coursePageRepositoryImpl = CoursePageRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
  });
  test(
      'get a Categories if remoteDataSource.getCategories completes successfully',
      () {
    when(remoteDataSource.getCoursePage(coursePageId)).thenAnswer(
      (_) async => coursePageModel,
    );
    expect(
      coursePageRepositoryImpl.getCoursePage(coursePageId),
      isA<Future<CoursePageEntity>>(),
    );
  });

  test(
      'throw an exception if remoteDataSource.getCategories completes with error',
      () {
    when(remoteDataSource.getCoursePage(coursePageId)).thenAnswer(
      (_) => throw Exception(),
    );
    expect(
      coursePageRepositoryImpl.getCoursePage(coursePageId),
      throwsException,
    );
  });
}
