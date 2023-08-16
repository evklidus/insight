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
  @override
  Future<User> getUser() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return _fromFirestoreToUser(userId!, userDoc.data());
  }
}

User _fromFirestoreToUser(
  String id,
  Map<String, dynamic>? userData,
) =>
    User(
      id: id,
      email: userData!['email'],
      avatarUrl: userData['avatar_url'],
      firstName: userData['first_name'],
      lastName: userData['last_name'],
    );
