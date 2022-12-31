import 'package:insight/services/http/rest_client.dart';

abstract class ProgramPageRemoteDataSource {
  Future<ProgramPageModel?> getProgramPage(int id);
}

class ProgramPageRemoteDataSourceImpl implements ProgramPageRemoteDataSource {
  final RestClient client;

  ProgramPageRemoteDataSourceImpl(this.client);

  @override
  Future<ProgramPageModel?> getProgramPage(int id) async {
    final programPage = await client.getProgramPage(id);
    return programPage;
  }
}
