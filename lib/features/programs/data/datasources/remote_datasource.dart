import 'package:m_sport/features/programs/data/models/program_model.dart';
import 'package:m_sport/services/http/rest_client.dart';

abstract class ProgramsRemoteDataSource {
  Future<List<ProgramModel>> getPrograms();
}

class ProgramsRemoteDataSourceImpl implements ProgramsRemoteDataSource {
  final RestClient client;

  ProgramsRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProgramModel>> getPrograms() async {
    final List<ProgramModel> programs = await client.getPrograms();
    return programs;
  }
}
