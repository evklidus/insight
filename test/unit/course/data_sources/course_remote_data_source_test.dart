// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:insight/src/features/course/data/course_network_data_provider.dart';
// import 'package:insight/src/features/course/model/course.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'course_remote_data_source_test.mocks.dart';

// class CourseFake extends Fake implements Course {}

// @GenerateMocks([Dio])
// void main() {
//   late final CourseNetworkDataProviderImpl coursesNetworkDataProvider;
//   final MockRestClient mockRestClient = MockRestClient();
//   final courses = [
//     CourseFake(),
//     CourseFake(),
//     CourseFake(),
//   ];
//   const categoryTag = 'sport';

//   setUpAll(() {
//     coursesNetworkDataProvider = CourseNetworkDataProviderImpl(mockRestClient);
//   });

//   test(
//       'get a Categories if mockRestClient.getCategories completes successfully',
//       () {
//     when(mockRestClient.getCoursesByCategoryTag(categoryTag)).thenAnswer(
//       (_) async => courses,
//     );
//     expect(
//       coursesNetworkDataProvider.getCourse(categoryTag),
//       completion(courses),
//     );
//   });

//   test(
//       'throw an exception if mockRestClient.getCategories completes with error',
//       () {
//     when(mockRestClient.getCoursesByCategoryTag(categoryTag)).thenAnswer(
//       (_) => throw Exception(),
//     );
//     expect(
//       coursesNetworkDataProvider.getCourse(categoryTag),
//       throwsException,
//     );
//   });
// }
