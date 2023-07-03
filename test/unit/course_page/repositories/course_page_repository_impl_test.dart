import 'package:flutter_test/flutter_test.dart';
import 'package:insight/features/course_page/data/data_sources/course_page_remote_data_source.dart';
import 'package:insight/features/course_page/data/repositories/course_page_repository.dart';
import 'package:insight/features/course_page/data/entities/course_page_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/rest_client.dart';

import 'course_page_repository_impl_test.mocks.dart';

class CoursePageDTOFake extends Fake implements CoursePageDTO {
  @override
  int get id => 1;

  @override
  String get imageUrl => 'imageUrl';

  @override
  List<LessonDTO> get lessons => [
        const LessonDTO(
          name: 'name',
          videoUrl: 'videoUrl',
        ),
      ];
}

@GenerateMocks([CoursePageRemoteDataSource])
void main() {
  late final CoursePageRepositoryImpl coursePageRepositoryImpl;
  late final remoteDataSource = MockCoursePageRemoteDataSource();
  final coursePageDTO = CoursePageDTOFake();
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
      (_) async => coursePageDTO,
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
