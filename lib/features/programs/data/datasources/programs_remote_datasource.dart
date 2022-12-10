import 'package:insight/features/programs/data/models/program_model.dart';
import 'package:insight/services/http/rest_client.dart';

abstract class ProgramsRemoteDataSource {
  Future<List<ProgramModel>?> getPrograms();
}

class ProgramsRemoteDataSourceImpl implements ProgramsRemoteDataSource {
  final RestClient client;

  ProgramsRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProgramModel>?> getPrograms() async {
    final programs = await client.getPrograms();
    return programs;
  }
}
