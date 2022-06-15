import 'package:m_sport/features/programs/data/models/program_model.dart';
import 'package:m_sport/services/http/rest_client.dart';

abstract class ProgramsRemoteDataSource {
  /// Calls the https://cicdtest-e5722-default-rtdb.europe-west1.firebasedatabase.app endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ProgramModel>> getPrograms();
}

class ProgramsRemoteDataSourceImpl implements ProgramsRemoteDataSource {
  final RestClient client;

  ProgramsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProgramModel>> getPrograms() async {
    final List<ProgramModel> programs = await client.getPrograms();
    return programs;
  }
}
