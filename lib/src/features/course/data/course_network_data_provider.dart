import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insight/src/features/course/model/course.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
abstract interface class CourseNetworkDataProvider {
  Future<List<Course>> getCourse(String categoryTag);

  Future<List<Course>> getUserCourse();

  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
    bool isClosed = false,
  });

  Future<List<({String categoryName, String categoryTag})>> getCategoryTags();
}

@immutable
final class CourseNetworkDataProviderImpl implements CourseNetworkDataProvider {
  const CourseNetworkDataProviderImpl(Dio client) : _client = client;

  final Dio _client;

  @override
  Future<List<Course>> getCourse(String categoryTag) async {
    final response = await _client.get('/course/$categoryTag');
    return (response.data as List<Map>).map(Course.fromJson).toList();
  }

  @override
  Future<List<Course>> getUserCourse() async {
    final response = await _client.get('/course/my');
    return (response.data as List<Map>).map(Course.fromJson).toList();
  }

  @override
  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
    bool isClosed = false,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'description': description,
      'tag': categoryTag,
      'is_private': isClosed,
      'image': await MultipartFile.fromFile(imagePath, filename: 'course_image'),
    });
    await _client.post('/course', data: formData);
  }

  @override
  Future<List<({String categoryName, String categoryTag})>>
      getCategoryTags() async {
    final response = await _client.get('/category_tags');
    // TODO: Потом получать названия из локальной функции
    return (response.data as List<Map>)
        .map(
          (json) => (
            categoryName: json['name'] as String,
            categoryTag: json['tag'] as String,
          ),
        )
        .toList();
  }
}

@immutable
final class CourseFirestoreDataProviderImpl
    implements CourseNetworkDataProvider {
  const CourseFirestoreDataProviderImpl(
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
  Future<List<Course>> getCourse(String categoryTag) async {
    final coursesCollection = await _firestore
        .collection('course')
        .where('tag', isEqualTo: categoryTag)
        .get();

    final courses = coursesCollection.docs
        .map((doc) => Course.fromFirestore(doc.id, doc.data()))
        .toList();

    // TODO: Тестово — первый по id курс закрытый. Удалить когда бэкенд будет отдавать is_closed
    if (courses.isNotEmpty) {
      final sorted = List<Course>.from(courses)
        ..sort((a, b) => a.id.compareTo(b.id));
      final firstId = sorted.first.id;
      return courses
          .map((c) => c.id == firstId ? Course(
                id: c.id,
                name: c.name,
                imageUrl: c.imageUrl,
                tag: c.tag,
                creatorId: c.creatorId,
                isClosed: true,
              ) : c)
          .toList();
    }
    return courses;
  }

  @override
  Future<List<Course>> getUserCourse() async {
    final userId = _firebaseAuth.currentUser!.uid;

    final coursesCollection = await _firestore
        .collection('course')
        .where('owner_id', isEqualTo: userId)
        .get();

    final courses = coursesCollection.docs
        .map((doc) => Course.fromFirestore(doc.id, doc.data()))
        .toList();

    // TODO: Тестово — первый по id курс закрытый. Удалить когда бэкенд будет отдавать is_closed
    if (courses.isNotEmpty) {
      final sorted = List<Course>.from(courses)
        ..sort((a, b) => a.id.compareTo(b.id));
      final firstId = sorted.first.id;
      return courses
          .map((c) => c.id == firstId ? Course(
                id: c.id,
                name: c.name,
                imageUrl: c.imageUrl,
                tag: c.tag,
                creatorId: c.creatorId,
                isClosed: true,
              ) : c)
          .toList();
    }
    return courses;
  }

  @override
  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
    bool isClosed = false,
  }) async {
    // Загружаем обложку в firebase storage
    final file = File(imagePath);

    final uploadTask = await _firebaseStorage
        .ref()
        .child('images')
        .child('courses')
        .child(name)
        .child('/${name}_main_photo')
        .putFile(file);

    final imageUrl = await uploadTask.ref.getDownloadURL();

    final userId = _firebaseAuth.currentUser!.uid;

    // Сохраняем курс в firestore
    // TODO: передать is_closed когда бэкенд будет поддерживать
    final courseCollection = _firestore.collection('course');
    final doc = await courseCollection.add({
      'name': name,
      'image_url': imageUrl,
      'tag': categoryTag,
      'owner_id': userId,
    });

    doc.collection('detail').add(
      {
        'description': description,
      },
    );
  }

  @override
  Future<List<({String categoryName, String categoryTag})>>
      getCategoryTags() async {
    final categoriesCollection = await _firestore.collection('category').get();
    final categories = categoriesCollection.docs
        .map(
          (doc) => (
            categoryName: doc.data()['name'] as String,
            categoryTag: doc.data()['tag'] as String,
          ),
        )
        .toList();
    return categories;
  }
}
