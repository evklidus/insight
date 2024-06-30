import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/features/profile/model/user.dart';
import 'package:insight/src/features/profile/model/user_edit.dart';

abstract interface class ProfileNetworkDataProvider {
  Future<User> getUser();
  Future<void> editUser(User$Edit user);
}

// final class ProfileNetworkDataProviderImpl
//     implements ProfileNetworkDataProvider {
//   const ProfileNetworkDataProviderImpl(RestClient client) : _client = client;

//   final RestClient _client;

//   @override
//   Future<User> getUser() => _client.getUser().then(User.fromDTO);
// }

final class ProfileFirestoreDataProviderImpl
    implements ProfileNetworkDataProvider {
  const ProfileFirestoreDataProviderImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
    required FirebaseStorage firebaseStorage,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth,
        _firebaseStorage = firebaseStorage;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  @override
  Future<User> getUser() async {
    final userId = _firebaseAuth.currentUser?.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return User.fromFirestore(userId!, userDoc.data());
  }

  @override
  Future<void> editUser(User$Edit user) async {
    // Upload avatar
    String? avatarUrl;

    if (user.avatarPath.isNotNull) {
      final uploadTask = await _firebaseStorage
          .ref()
          .child('images')
          .child('users')
          .child(user.id)
          .child('${user.id}_avatar')
          .putFile(File(user.avatarPath!));

      avatarUrl = await uploadTask.ref.getDownloadURL();
    }

    // Update user data
    await _firestore.collection('users').doc(user.id).update({
      if (user.firstName.isNotNull) 'first_name': user.firstName,
      if (user.lastName.isNotNull) 'last_name': user.lastName,
      if (avatarUrl.isNotNull) 'avatar_url': avatarUrl,
    });
  }
}
