import 'package:auth_client/auth_client.dart';
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
  AuthNetworkDataProviderImpl(AuthClient authClient) : _authClient = authClient;

  final AuthClient _authClient;

  @override
  Future<void> register(
    String email,
    String password,
  ) =>
      _authClient.register(email, password);

  @override
  Future<Token> login(
    String email,
    String password,
  ) =>
      _authClient.login(email, password).then(Token.fromDTO);

  @override
  Future<void> logout() async {}
}

final class AuthFirebaseDataProviderImpl implements AuthNetworkDataProvider {
  const AuthFirebaseDataProviderImpl(FirebaseAuth firebaseAuth)
      : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> register(
    String email,
    String password,
  ) =>
      _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
    return Token(accessToken: idToken!, refreshToken: refreshToken);
  }

  @override
  Future<void> logout() => _firebaseAuth.signOut();
}
