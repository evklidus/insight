import 'package:flutter_test/flutter_test.dart';
import 'package:m_sport/core/errors/exceptions.dart';
import 'package:m_sport/features/program_page/data/datasources/program_page_remote_datasource.dart';
import 'package:m_sport/features/program_page/data/models/program_page_model.dart';
import 'package:m_sport/services/http/rest_client.dart';
import 'package:m_sport/utilities/load_states.dart';
import 'package:mocktail/mocktail.dart';

import '../../utilities/loaded_utilities.dart';

class MockRestClient extends Mock implements RestClient {}

class FakeProgramPageModel extends Fake implements ProgramPageModel {}

void main() {
  late ProgramPageRemoteDataSourceImpl dataSource;
  late RestClient client;
  late LoadedUtils<ProgramPageModel> loadedUtils;
  const programPageId = 1;
  final programPage = FakeProgramPageModel();
  final serverException = ServerException();

  setUp(() {
    client = MockRestClient();
    dataSource = ProgramPageRemoteDataSourceImpl(client);
    loadedUtils = LoadedUtils<ProgramPageModel>();
  });

  group('load', () {
    _test(LoadStates state) async {
      late dynamic result;
      final loadedResult = loadedUtils.returnForDataSource(state: state, entity: programPage);
      when(() => client.getProgramPage(programPageId)).thenAnswer((_) async {
        if (state == LoadStates.failed) {
          throw serverException;
        }
        return loadedResult;
      });
      try {
        result = await dataSource.getProgramPage(programPageId);
      } catch (e) {
        result = serverException;
      }
      expect(result, state == LoadStates.failed ? serverException : loadedResult);
      verify(() => client.getProgramPage(programPageId)).called(1);
    }

    test('successful', () async {
      await _test(LoadStates.successful);
    });

    test('failed', () async {
      await _test(LoadStates.failed);
    });

    test('empty', () async {
      await _test(LoadStates.empty);
    });
  });
}
