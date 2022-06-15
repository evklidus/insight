import 'package:m_sport/features/programs/data/models/program_model.dart';
import 'package:m_sport/features/trainings/data/models/program_page_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://cicdtest-e5722-default-rtdb.europe-west1.firebasedatabase.app/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/programs.json')
  Future<List<ProgramModel>> getPrograms();

  @GET('/full_program/{id}.json')
  Future<ProgramPageModel> getProgramPage(@Path('id') int id);
}
