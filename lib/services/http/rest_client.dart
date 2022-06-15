import 'package:m_sport/features/programs/data/models/program_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://cicdtest-e5722-default-rtdb.europe-west1.firebasedatabase.app/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/programs.json')
  Future<List<ProgramModel>> getPrograms();

  // @GET('/programs/{id}')
  // Future<List<Training>> getTrainings(@Path('id') String id); // TODO: Model !!!
}
