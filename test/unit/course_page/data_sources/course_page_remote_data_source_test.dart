import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/course_page/data/course_page_network_data_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/rest_client.dart';

import 'course_page_remote_data_source_test.mocks.dart';

class CoursePageDTOFake extends Fake implements CoursePageDTO {}

@GenerateMocks([RestClient])
void main() {
  late final CoursePageNetworkDataProviderImpl
      coursePageNetworkDataProviderImpl;
  final MockRestClient mockRestClient = MockRestClient();
  final coursePage = CoursePageDTOFake();
  const coursePageId = '1';

  setUpAll(() {
    coursePageNetworkDataProviderImpl =
        CoursePageNetworkDataProviderImpl(mockRestClient);
  });

  test(
      'get a CoursePage if mockRestClient.getCoursePage completes successfully',
      () {
    when(mockRestClient.getCoursePage(coursePageId)).thenAnswer(
      (_) async => coursePage,
    );
    expect(
      coursePageNetworkDataProviderImpl.getCoursePage(coursePageId),
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
      coursePageNetworkDataProviderImpl.getCoursePage(coursePageId),
      throwsException,
    );
  });
}
