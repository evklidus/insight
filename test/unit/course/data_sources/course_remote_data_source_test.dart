import 'package:flutter_test/flutter_test.dart';
import 'package:insight/src/features/course/data/course_network_data_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/rest_client.dart';

import 'course_remote_data_source_test.mocks.dart';

class CourseDTOFake extends Fake implements CourseDTO {}

@GenerateMocks([RestClient])
void main() {
  late final CourseNetworkDataProviderImpl coursesNetworkDataProvider;
  final MockRestClient mockRestClient = MockRestClient();
  final courses = [
    CourseDTOFake(),
    CourseDTOFake(),
    CourseDTOFake(),
  ];
  const categoryTag = 'sport';

  setUpAll(() {
    coursesNetworkDataProvider = CourseNetworkDataProviderImpl(mockRestClient);
  });

  test(
      'get a Categories if mockRestClient.getCategories completes successfully',
      () {
    when(mockRestClient.getCoursesByCategoryTag(categoryTag)).thenAnswer(
      (_) async => courses,
    );
    expect(
      coursesNetworkDataProvider.getCourse(categoryTag),
      completion(courses),
    );
  });

  test(
      'throw an exception if mockRestClient.getCategories completes with error',
      () {
    when(mockRestClient.getCoursesByCategoryTag(categoryTag)).thenAnswer(
      (_) => throw Exception(),
    );
    expect(
      coursesNetworkDataProvider.getCourse(categoryTag),
      throwsException,
    );
  });
}
