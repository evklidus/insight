import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/course_page/data/data_sources/course_page_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/rest_client.dart';

import 'course_page_remote_data_source_test.mocks.dart';

class CoursePageDTOFake extends Fake implements CoursePageDTO {}

@GenerateMocks([RestClient])
void main() {
  late final CoursePageRemoteDataSourceImpl coursePageRemoteDataSourceImpl;
  final MockRestClient mockRestClient = MockRestClient();
  final coursePage = CoursePageDTOFake();
  const coursePageId = 1;

  setUpAll(() {
    coursePageRemoteDataSourceImpl =
        CoursePageRemoteDataSourceImpl(mockRestClient);
  });

  test(
      'get a CoursePage if mockRestClient.getCoursePage completes successfully',
      () {
    when(mockRestClient.getCoursePage(coursePageId)).thenAnswer(
      (_) async => coursePage,
    );
    expect(
      coursePageRemoteDataSourceImpl.getCoursePage(coursePageId),
      completion(coursePage),
    );
  });

  test(
      'throw an exception if mockRestClient.getCoursePage completes with error',
      () {
    when(mockRestClient.getCoursePage(coursePageId)).thenAnswer(
      (_) => throw Exception(),
    );
    expect(
      coursePageRemoteDataSourceImpl.getCoursePage(coursePageId),
      throwsException,
    );
  });
}
