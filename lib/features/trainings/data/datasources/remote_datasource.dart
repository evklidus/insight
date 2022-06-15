import 'package:m_sport/features/trainings/data/models/program_page_model.dart';
import 'package:m_sport/services/http/rest_client.dart';

abstract class ProgramPageRemoteDataSource {
  /// Calls the https://cicdtest-e5722-default-rtdb.europe-west1.firebasedatabase.app/full_program/{id}.json endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ProgramPageModel> getProgramPage(int id);
}

class ProgramPageRemoteDataSourceImpl implements ProgramPageRemoteDataSource {
  final RestClient client;

  ProgramPageRemoteDataSourceImpl(this.client);

  @override
  Future<ProgramPageModel> getProgramPage(int id) async {
    final programPage = await client.getProgramPage(id);
    return programPage;
  }
}
