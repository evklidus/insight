import 'package:meta/meta.dart';
import 'package:rest_client/src/dto/category/category_dto.dart';
import 'package:rest_client/src/dto/course_page/course_page_dto.dart';
import 'package:rest_client/src/dto/course/course_dto.dart';
import 'package:rest_client/src/dto/user/user_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

const _baseUrl = 'http://0.0.0.0:8080';
const _getCategories = '/categories';
const _getCourseByCategory = '/course/{category}';
const _getCoursePageById = '/course_pages/{id}';
const _getUser = '/get_user';

@RestApi(baseUrl: _baseUrl)
@immutable
abstract class RestClient {
  factory RestClient(
    Dio dio, {
    String baseUrl,
  }) = _RestClient;

  @GET(_getCategories)
  Future<List<CategoryDTO>> getCategories();

  @GET(_getCourseByCategory)
  Future<List<CourseDTO>> getCourseByCategoryTag(
    @Path('category') String categoryTag,
  );

  @GET(_getCoursePageById)
  Future<CoursePageDTO> getCoursePage(
    @Path('id') int id,
  );

  @GET(_getUser)
  Future<UserDTO> getUser();
}
