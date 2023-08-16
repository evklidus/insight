import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:insight/src/features/profile/model/user.dart';
import 'package:rest_client/rest_client.dart';

abstract interface class ProfileNetworkDataProvider {
  Future<User> getUser();
}

final class ProfileNetworkDataProviderImpl
    implements ProfileNetworkDataProvider {
  const ProfileNetworkDataProviderImpl(RestClient client) : _client = client;

  final RestClient _client;

  @override
  Future<User> getUser() => _client.getUser().then(User.fromDTO);
}

final class ProfileFirestoreDataProviderImpl
    implements ProfileNetworkDataProvider {
  const ProfileFirestoreDataProviderImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<User> getUser() async {
    final userId = _firebaseAuth.currentUser?.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return User.fromFirestore(userId!, userDoc.data());
  }
}
