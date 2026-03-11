import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/features/course_page/model/course_edit.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';
import 'package:insight/src/features/course_page/model/invitation.dart';
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

  /// Отправляет приглашение пользователю на просмотр закрытого курса.
  Future<void> sendInvitation({
    required String courseId,
    required String emailOrNickname,
  });

  /// Возвращает список приглашённых на курс.
  Future<List<Invitation>> getInvitations(String courseId);
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
  }) async {
    final formData = FormData.fromMap({
      'courseId': courseId,
      'name': lessonName,
      'video': await MultipartFile.fromFile(
        videoPath,
        filename: 'lesson_video',
      ),
    });
    await _client.post('/lessons', data: formData);
  }

  @override
  Future<void> removeLesson({
    required String courseId,
    required Lesson lesson,
  }) =>
      _client.delete(
        '/lessons/$courseId/${Uri.encodeComponent(lesson.id.isNotEmpty ? lesson.id : lesson.name)}',
      );

  @override
  Future<void> editCourse(Course$Edit course) async {
    final formData = FormData.fromMap({
      if (course.name.isNotNull) 'name': course.name,
      if (course.description.isNotNull) 'description': course.description,
      if (course.tag.isNotNull) 'tag': course.tag,
      if (course.imagePath.isNotNull)
        'image': await MultipartFile.fromFile(
          course.imagePath!,
          filename: 'course_image',
        ),
    });
    await _client.patch('/course_pages/${course.id}', data: formData);
  }

  @override
  Future<void> sendInvitation({
    required String courseId,
    required String emailOrNickname,
  }) async {
    final isEmail = emailOrNickname.contains('@');
    final data =
        isEmail ? {'email': emailOrNickname} : {'username': emailOrNickname};
    await _client.post('/courses/$courseId/invitations', data: data);
  }

  @override
  Future<List<Invitation>> getInvitations(String courseId) async {
    final response = await _client.get('/courses/$courseId/invitations');

    if (response.data
        case {'message': final String message, 'statusCode': final int code}) {
      throw Exception('[$code] $message');
    }

    if (response.data case final List invitationsJson) {
      return invitationsJson
          .cast<Map<String, dynamic>>()
          .map(Invitation.fromJson)
          .toList(growable: false);
    }

    throw FormatException(
      'Unexpected getInvitations response',
      response.data,
    );
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

    var coursePage = CoursePage.fromFirestore(
      courseData.id,
      courseData.data(),
      courseDetailData.data(),
      userId,
    );

    // TODO: Тестово — первый по id в категории закрытый. Удалить когда бэкенд будет отдавать is_closed
    final tag = courseData.data()?['tag'] as String?;
    if (tag != null) {
      final inCategory = await _firestore
          .collection('course')
          .where('tag', isEqualTo: tag)
          .get();
      final ids = inCategory.docs.map((d) => d.id).toList()..sort();
      if (ids.isNotEmpty && ids.first == id) {
        coursePage = coursePage.copyWith(isClosed: true);
      }
    }
    return coursePage;
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

    // TODO: передать is_closed в update когда бэкенд будет поддерживать
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
      'id': uploadTask.ref.name,
      'name': lessonName,
      'video_url': videoUrl,
      'completed': false,
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
    existingLessons.removeWhere(
      (element) =>
          element['id'] == lesson.id ||
          (lesson.id.isEmpty && element['name'] == lesson.name),
    );

    detailDocData['lessons'] = existingLessons;

    // Обновляем список уроков в документе "detail"
    detailDoc.docs.first.reference.update(detailDocData);
  }

  @override
  Future<void> sendInvitation({
    required String courseId,
    required String emailOrNickname,
  }) async {
    // TODO: заглушка — приглашение не отправляется
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<Invitation>> getInvitations(String courseId) async {
    // TODO: заглушка — мок-данные для демонстрации
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [
      const Invitation(
        inviteeEmail: 'ivan@example.com',
        inviteeUsername: null,
        status: InvitationStatus.accepted,
      ),
      const Invitation(
        inviteeEmail: null,
        inviteeUsername: 'maria',
        status: InvitationStatus.accepted,
      ),
      const Invitation(
        inviteeEmail: 'petr@mail.ru',
        inviteeUsername: null,
        status: InvitationStatus.pending,
      ),
    ];
  }
}
