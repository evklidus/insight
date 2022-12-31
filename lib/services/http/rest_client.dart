import 'package:insight/core/constants/http_constants.dart';
import 'package:insight/features/categories/data/models/category_model.dart';
import 'package:insight/features/courses_preview/data/models/course_preview_model.dart';
import 'package:insight/features/course_page/data/models/program_page_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: HttpConstants.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET(HttpConstants.getCategories)
  Future<List<CategoryModel>?> getCategories();

  @GET(HttpConstants.getCoursesPreviewByCategoryTag)
  Future<List<CoursePreviewModel>?> getCoursesPreviewByCategoryTag(
    @Path(HttpConstants.getCoursesPreviewByCategoryTagPath) String categoryTag,
  );

  @GET(HttpConstants.getCourse)
  Future<ProgramPageModel?> getCourseByName(
    @Path(HttpConstants.getCoursePath) String courseName,
  );
}
