import 'dart:io';

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

  final RestClient _client;

  @override
  Future<List<Course>> getCourse(String categoryTag) => _client
      .getCoursesByCategoryTag(categoryTag)
      .then((list) => list.map(Course.fromDTO).toList());

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
    FirebaseFirestore firestore,
    FirebaseStorage firebaseStorage,
  )   : _firestore = firestore,
        _firebaseStorage = firebaseStorage;

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
    return courses;
  }

  @override
  Future<void> createCourse({
    required String name,
    required String description,
    required String imagePath,
    required String categoryTag,
  }) async {
    final file = File(imagePath);

    final uploadTask = await _firebaseStorage
        .ref()
        .child('images')
        .child('courses')
        .child(name)
        .child('/${name}_main_photo')
        .putFile(file);

    final imageUrl = await uploadTask.ref.getDownloadURL();

    // Сохраняем курс в firestore
    final courseCollection = _firestore.collection('course');
    final doc = await courseCollection.add({
      'name': name,
      'image_url': imageUrl,
      'tag': categoryTag,
    });
    // TODO: detail и тд вынести в константы (в этом файле)
    doc.collection('detail').add(
      {
        'description': description,
      },
    );
  }
}
