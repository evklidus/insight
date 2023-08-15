import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';
import 'package:rest_client/rest_client.dart';

abstract interface class CoursePageNetworkDataProvider {
  Future<CoursePage> getCoursePage(String id);
}

final class CoursePageNetworkDataProviderImpl
    implements CoursePageNetworkDataProvider {
  const CoursePageNetworkDataProviderImpl(RestClient client) : _client = client;

  final RestClient _client;

  @override
  Future<CoursePage> getCoursePage(String id) =>
      _client.getCoursePage(id).then(CoursePage.fromDTO);
}

final class CoursePageFirestoreDataProviderImpl
    implements CoursePageNetworkDataProvider {
  @override
  Future<CoursePage> getCoursePage(String id) async {
    final firestore = FirebaseFirestore.instance;
    final courseDoc = firestore.collection('course').doc(id);
    final courseData = await courseDoc.get();
    final courseDetailCollection = await courseDoc.collection('detail').get();
    final courseDetailData = courseDetailCollection.docs.first;
    return _fromFirestoreToCourse(
      courseData.id,
      courseData.data(),
      courseDetailData.data(),
    );
  }
}

CoursePage _fromFirestoreToCourse(
  String id,
  Map<String, dynamic>? courseData,
  Map<String, dynamic>? detailData,
) =>
    CoursePage(
      id: id,
      imageUrl: courseData!['image_url'],
      lessons: List.of(detailData!['lessons'])
          .map(
            (lessonData) => Lesson(
              name: lessonData['name'],
              videoUrl: lessonData['video_url'],
            ),
          )
          .toList(),
    );
