import 'package:insight/core/constants/string_constants.dart';
import 'package:insight/features/programs/data/models/program_model.dart';
import 'package:insight/features/program_page/data/models/program_page_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: StringConstants.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET(StringConstants.programsGetUrl)
  Future<List<ProgramModel>?> getPrograms();

  @GET(StringConstants.fullProgramGetUrl)
  Future<ProgramPageModel?> getProgramPage(
      @Path(StringConstants.fullProgramGetPath) int id);
}
