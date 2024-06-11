import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';
import 'package:rest_client/rest_client.dart';

abstract interface class CoursePageNetworkDataProvider {
  Future<CoursePage> getCoursePage(String id);

  Future<void> addLesson({
    required String courseId,
    required String lessonName,
    required String videoPath,
  });

  Future<void> removeLesson({
    required String courseId,
    required Lesson lesson,
  });

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

  @override
  Future<void> addLesson({
    required String courseId,
    required String lessonName,
    required String videoPath,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> removeLesson({
    required String courseId,
    required Lesson lesson,
  }) {
    throw UnimplementedError();
  }
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
  Future<void> addLesson({
    required String courseId,
    required String lessonName,
    required String videoPath,
  }) async {
    // Загружаем видео в firebase storage
    final file = File(videoPath);

    final videoName = lessonName.replaceAll(' ', '_');

    final uploadTask = await _firebaseStorage
        .ref()
        .child('courses')
        .child(courseId)
        .child('lessons')
        // TODO: Заменить на lesson id
        .child(videoName)
        .child('videos')
        .child('/${videoName}_video')
        .putFile(file);

    // Получаем url видео
    final videoUrl = await uploadTask.ref.getDownloadURL();

    // Получаем ссылку на документ курса
    final courseDoc = _firestore.collection('course').doc(courseId);

    final detailDoc = await courseDoc.collection('detail').get();

    final detailDocData = detailDoc.docs.first.data();

    // Получаем текущий список уроков
    final List existingLessons = detailDocData['lessons'] ?? [];

    // Добавляем новый урок в список
    existingLessons.add({
      'name': lessonName,
      'video_url': videoUrl,
    });

    detailDocData['lessons'] = existingLessons;

    // Обновляем список уроков в документе "detail"
    detailDoc.docs.first.reference.update(detailDocData);
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

  @override
  Future<void> removeLesson({
    required String courseId,
    required Lesson lesson,
  }) async {
    final videoName = lesson.name.replaceAll(' ', '_');

    // Удаляем видео урока
    await _firebaseStorage
        .ref()
        .child('courses')
        .child(courseId)
        .child('lessons')
        // TODO: Заменить на lesson id
        .child(videoName)
        .child('videos')
        .child('/${videoName}_video')
        .delete();

    // Получаем ссылку на документ курса
    final courseDoc = _firestore.collection('course').doc(courseId);

    final detailDoc = await courseDoc.collection('detail').get();

    final detailDocData = detailDoc.docs.first.data();

    // Получаем текущий список уроков
    final List existingLessons = detailDocData['lessons'] ?? [];

    // Удаляем урок из списока
    existingLessons.removeWhere((element) => element['name'] == lesson.name);

    detailDocData['lessons'] = existingLessons;

    // Обновляем список уроков в документе "detail"
    detailDoc.docs.first.reference.update(detailDocData);
  }
}
