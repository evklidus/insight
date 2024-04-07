import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:rest_client/rest_client.dart';

abstract interface class CoursePageNetworkDataProvider {
  Future<CoursePage> getCoursePage(String id);

  Future<void> deleteCourse({
    required String courseId,
    // Нужно чтобы удалить обложку
    required String imageUrl,
  });
}

final class CoursePageNetworkDataProviderImpl
    implements CoursePageNetworkDataProvider {
  const CoursePageNetworkDataProviderImpl(RestClient client) : _client = client;
// ignore: unused_field
  final RestClient _client;

  @override
  Future<CoursePage> getCoursePage(String id) => throw UnimplementedError();
  // _client.getCoursePage(id).then(CoursePage.fromDTO);

  @override
  Future<void> deleteCourse({
    required String courseId,
    required String imageUrl,
  }) =>
      throw UnimplementedError();
}

final class CoursePageFirestoreDataProviderImpl
    implements CoursePageNetworkDataProvider {
  const CoursePageFirestoreDataProviderImpl(
    FirebaseAuth firebaseAuth,
    FirebaseFirestore firestore,
    FirebaseStorage firebaseStorage,
  )   : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _firebaseStorage = firebaseStorage;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  @override
  Future<CoursePage> getCoursePage(String id) async {
    final courseDoc = _firestore.collection('course').doc(id);
    final courseData = await courseDoc.get();
    final courseDetailCollection = await courseDoc.collection('detail').get();
    final courseDetailData = courseDetailCollection.docs.first;

    final userId = _firebaseAuth.currentUser!.uid;

    return CoursePage.fromFirestore(
      courseData.id,
      courseData.data(),
      courseDetailData.data(),
      userId,
    );
  }

  @override
  Future<void> deleteCourse({
    required String courseId,
    required String imageUrl,
  }) async {
    // Удаляем курс с Firestore
    final courseCollection = _firestore.collection('course');
    await courseCollection.doc(courseId).delete();

    // Удаляем обложку
    await _firebaseStorage.refFromURL(imageUrl).delete();
  }
}
