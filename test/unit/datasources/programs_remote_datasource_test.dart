import 'package:flutter_test/flutter_test.dart';
import 'package:insight/core/errors/exceptions.dart';
import 'package:insight/features/courses_preview/data/datasources/courses_preview_remote_datasource.dart';
import 'package:insight/features/courses_preview/data/models/course_preview_model.dart';
import 'package:insight/services/http/rest_client.dart';
import 'package:insight/utilities/load_states.dart';
import 'package:mocktail/mocktail.dart';

import '../../utilities/loaded_utilities.dart';

class MockRestClient extends Mock implements RestClient {}

class FakeProgramModel extends Fake implements ProgramModel {}

void main() {
  late ProgramsRemoteDataSourceImpl dataSource;
  late RestClient client;
  late LoadedUtils<List<ProgramModel>> loadedUtils;
  final programs = [FakeProgramModel()];
  final serverException = ServerException();

  setUp(() {
    client = MockRestClient();
    dataSource = ProgramsRemoteDataSourceImpl(client);
    loadedUtils = LoadedUtils<List<ProgramModel>>();
  });

  group('load', () {
    _test(LoadStates state) async {
      late dynamic result;
      final loadedResult =
          loadedUtils.returnForDataSource(state: state, entity: programs);
      when(() => client.getPrograms()).thenAnswer((_) async {
        if (state == LoadStates.failed) {
          throw serverException;
        }
        return loadedResult;
      });
      try {
        result = await dataSource.getPrograms();
      } catch (e) {
        result = serverException;
      }
      expect(
          result, state == LoadStates.failed ? serverException : loadedResult);
      verify(() => client.getPrograms()).called(1);
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
