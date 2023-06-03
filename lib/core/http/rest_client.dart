import 'package:insight/common/constants/http_constants.dart';
import 'package:insight/features/categories/data/models/category_model.dart';
import 'package:insight/features/course_previews/data/models/course_preview_model.dart';
import 'package:insight/features/course_page/data/models/course_page_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: HttpConstants.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET(HttpConstants.getCategories)
  Future<List<CategoryModel>> getCategories();

  @GET(HttpConstants.getCoursePreviewsByCategory)
  Future<List<CoursePreviewModel>> getCoursePreviewsByCategoryTag(
    @Path('category') String categoryTag,
  );

  @GET(HttpConstants.getCoursePageById)
  Future<CoursePageModel> getCoursePage(
    @Path('id') int id,
  );
}
