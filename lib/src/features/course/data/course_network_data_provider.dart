import 'package:insight/src/features/course/model/course.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
abstract interface class CourseNetworkDataProvider {
  Future<List<Course>> getCourse(String categoryTag);
}

@immutable
final class CourseNetworkDataProviderImpl implements CourseNetworkDataProvider {
  const CourseNetworkDataProviderImpl(RestClient client) : _client = client;

  final RestClient _client;

  @override
  Future<List<Course>> getCourse(String categoryTag) => _client
      .getCoursesByCategoryTag(categoryTag)
      .then((list) => list.map(Course.fromDTO).toList());
}

@immutable
final class CourseFirestoreDataProviderImpl
    implements CourseNetworkDataProvider {
  const CourseFirestoreDataProviderImpl(FirebaseFirestore firestore)
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

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
}
