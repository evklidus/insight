import 'package:auth_client/src/dto/token_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

const _apiVersion = '/v1';
const _prefix = '/auth';
const _baseUrl = 'http://0.0.0.0:8080$_apiVersion$_prefix';

@RestApi(baseUrl: _baseUrl)
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST("/register")
  Future<void> register(
    @Query('username') String username,
    @Query('password') String password,
  );

  @POST("/login")
  @FormUrlEncoded()
  Future<TokenDTO> login(
    @Field('username') String username,
    @Field('password') String password,
  );

  @POST("/token")
  Future<TokenDTO> refreshToken(
    @Query('refresh_token') String refreshToken,
  );
}
