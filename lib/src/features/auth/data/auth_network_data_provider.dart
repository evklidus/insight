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
}

final class AuthFirebaseDataProviderImpl implements AuthNetworkDataProvider {
  @override
  Future<void> register(
    String email,
    String password,
  ) =>
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  Future<Token> login(
    String email,
    String password,
  ) async {
    // Авторизуемся в Firebase
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Получаем токен
    final idToken = await userCredential.user!.getIdToken();
    final refreshToken = userCredential.user!.refreshToken;
    return Token(accessToken: idToken!, refreshToken: refreshToken);
  }
}
