import 'package:flutter_test/flutter_test.dart';
import 'package:insight/core/http/rest_client.dart';
import 'package:insight/features/course_previews/data/data_sources/course_previews_remote_data_source.dart';
import 'package:insight/features/course_previews/data/models/course_preview_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_previews_remote_data_source_test.mocks.dart';

class CoursePreviewModelFake extends Fake implements CoursePreviewModel {}

@GenerateMocks([RestClient])
void main() {
  late final CoursePreviewsRemoteDataSourceImpl coursePreviewsRemoteDataSource;
  final MockRestClient mockRestClient = MockRestClient();
  final coursePreviews = [
    CoursePreviewModelFake(),
    CoursePreviewModelFake(),
    CoursePreviewModelFake(),
  ];
  const categoryTag = 'sport';

  setUpAll(() {
    coursePreviewsRemoteDataSource =
        CoursePreviewsRemoteDataSourceImpl(mockRestClient);
  });

  test(
      'get a Categories if mockRestClient.getCategories completes successfully',
      () {
    when(mockRestClient.getCoursePreviewsByCategoryTag(categoryTag)).thenAnswer(
      (_) async => coursePreviews,
    );
    expect(
      coursePreviewsRemoteDataSource.getCoursePreviews(categoryTag),
      completion(coursePreviews),
    );
  });

  test(
      'throw an exception if mockRestClient.getCategories completes with error',
      () {
    when(mockRestClient.getCoursePreviewsByCategoryTag(categoryTag)).thenAnswer(
      (_) => throw Exception(),
    );
    expect(
      coursePreviewsRemoteDataSource.getCoursePreviews(categoryTag),
      throwsException,
    );
  });
}
