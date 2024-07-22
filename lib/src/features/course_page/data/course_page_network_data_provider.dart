import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/features/course_page/model/course_edit.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';

abstract interface class CoursePageNetworkDataProvider {
  Future<CoursePage> getCoursePage(String id);

  Future<void> editCourse(Course$Edit course);

  Future<void> deleteCourse({
    required String courseId,
    // Нужно чтобы удалить обложку
    required String imageUrl,
  });

  Future<void> addLesson({
    required String courseId,
    required String lessonName,
    required String videoPath,
  });

  Future<void> removeLesson({
    required String courseId,
    required Lesson lesson,
  });
}

final class CoursePageNetworkDataProviderImpl
    implements CoursePageNetworkDataProvider {
  const CoursePageNetworkDataProviderImpl(Dio client) : _client = client;
  final Dio _client;

  @override
  Future<CoursePage> getCoursePage(String id) async {
    final response = await _client.get('/course_pages/$id');
    return CoursePage.fromJson(response.data);
  }

  @override
  Future<void> deleteCourse({
    required String courseId,
    required String imageUrl,
  }) =>
      _client.delete('/course_pages/$courseId');

  @override
  Future<void> addLesson({
    required String courseId,
    required String lessonName,
    required String videoPath,
  }) =>
      _client.post(
        '/lessons',
        data: {
          'courseId': courseId,
          'name': lessonName,
          'videoPath': videoPath,
        },
      );

  @override
  Future<void> removeLesson({
    required String courseId,
    required Lesson lesson,
  }) => // TODO: Заменить на lesson id
      _client.delete('/lessons/$courseId');

  @override
  Future<void> editCourse(Course$Edit course) {
    // TODO: implement editCourse
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

    final userId = _firebaseAuth.currentUser?.uid;

    return CoursePage.fromFirestore(
      courseData.id,
      courseData.data(),
      courseDetailData.data(),
      userId,
    );
  }

  @override
  Future<void> editCourse(Course$Edit course) async {
    String? imageUrl;

    if (course.imagePath.isNotNull) {
      // Compress avatar
      final splitterAvatarPath = course.imagePath!.split('.');
      splitterAvatarPath.insert(1, '_copmpressed');
      final compressedAvatarPath = splitterAvatarPath.join('.');

      final compressedAvatar = await FlutterImageCompress.compressAndGetFile(
        course.imagePath!,
        compressedAvatarPath,
        quality: 80,
      );

      final image = File(compressedAvatar!.path);

      // Upload avatar
      final uploadTask = await _firebaseStorage
          .ref()
          .child('images')
          .child('courses')
          .child(course.name)
          .child('${course.name}_main_photo')
          .putFile(image);

      imageUrl = await uploadTask.ref.getDownloadURL();
    }

    final courseDoc = _firestore.collection('course').doc(course.id);
    await courseDoc.update({
      if (course.name.isNotNull) 'name': course.name,
      if (course.imagePath.isNotNull) 'image_url': imageUrl,
      if (course.tag.isNotNull) 'tag': course.tag,
    });

    final detailDoc = await courseDoc.collection('detail').get();
    final detailDocPath = detailDoc.docs.first.id;
    courseDoc.collection('detail').doc(detailDocPath).update(
      {
        if (course.description.isNotNull) 'description': course.description,
      },
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
    // Удалаяем уроки курса
    await _firebaseStorage.ref().child('courses').child(courseId).delete();

    // Удаляем обложку
    await _firebaseStorage.refFromURL(imageUrl).delete();

    // Удаляем курс с Firestore
    final courseCollection = _firestore.collection('course');
    await courseCollection.doc(courseId).delete();
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
