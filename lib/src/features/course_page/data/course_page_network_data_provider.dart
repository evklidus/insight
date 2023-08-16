import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
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
  const CoursePageFirestoreDataProviderImpl(FirebaseFirestore firestore)
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<CoursePage> getCoursePage(String id) async {
    final courseDoc = _firestore.collection('course').doc(id);
    final courseData = await courseDoc.get();
    final courseDetailCollection = await courseDoc.collection('detail').get();
    final courseDetailData = courseDetailCollection.docs.first;
    return CoursePage.fromFirestore(
      courseData.id,
      courseData.data(),
      courseDetailData.data(),
    );
  }
}
