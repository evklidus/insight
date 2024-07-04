import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insight/src/features/auth/model/token.dart';

abstract interface class AuthNetworkDataProvider {
  Future<void> register(
    String email,
    String password,
  );

  Future<Token> login(
    String email,
    String password,
  );

  Future<void> logout();
}

final class AuthNetworkDataProviderImpl implements AuthNetworkDataProvider {
  AuthNetworkDataProviderImpl(Dio authClient) : _authClient = authClient;

  final Dio _authClient;

  @override
  Future<void> register(
    String email,
    String password,
  ) =>
      _authClient.post(
        '/register',
        data: {
          'email': email,
          'password': password,
        },
      );

  @override
  Future<Token> login(
    String email,
    String password,
  ) =>
      _authClient.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      ).then((r) => Token.fromJson(r.data));

  @override
  Future<void> logout() => _authClient.post('/logout');
}

final class AuthFirebaseDataProviderImpl implements AuthNetworkDataProvider {
  const AuthFirebaseDataProviderImpl(
      FirebaseAuth firebaseAuth, FirebaseFirestore firestore)
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<void> register(
    String email,
    String password,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Set email into user data
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'first_name': email.split('@')[0],
    });
  }

  // TODO: Вынестив в отдельный провайдер ИЛИ репо + рефреш токена
  @override
  Future<Token> login(
    String email,
    String password,
  ) async {
    // Авторизуемся в Firebase
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Получаем токен
    final idToken = await userCredential.user!.getIdToken();
    final refreshToken = userCredential.user!.refreshToken;
    return Token(accessToken: idToken!, refreshToken: refreshToken!);
  }

  @override
  Future<void> logout() => _firebaseAuth.signOut();
}
