import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insight/src/features/course/model/course.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
abstract interface class CourseNetworkDataProvider {
  Future<List<Course>> getCourse(String categoryTag);

  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
  });
}

@immutable
final class CourseNetworkDataProviderImpl implements CourseNetworkDataProvider {
  const CourseNetworkDataProviderImpl(RestClient client) : _client = client;
// ignore: unused_field
  final RestClient _client;

  @override
  Future<List<Course>> getCourse(String categoryTag) =>
      throw UnimplementedError();
  // _client
  //     .getCoursesByCategoryTag(categoryTag)
  //     .then((list) => list.map(Course.fromDTO).toList());

  @override
  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
  }) =>
      throw UnimplementedError();
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

    final userId = _firebaseAuth.currentUser!.uid;

    final courses = coursesCollection.docs
        .map((doc) => Course.fromFirestore(doc.id, doc.data(), userId))
        .toList();
    return courses;
  }

  @override
  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
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
    final courseCollection = _firestore.collection('course');
    final doc = await courseCollection.add({
      'name': name,
      'image_url': imageUrl,
      'tag': categoryTag,
      'owner_id': userId,
    });
    // TODO: detail и тд вынести в константы (в этом файле)
    doc.collection('detail').add(
      {
        'description': description,
      },
    );
  }
}
