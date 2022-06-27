import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/features/programs/domain/usecases/get_programs.dart';
import 'package:m_sport/features/programs/presentation/store/programs_store.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utilities/loaded_utilities.dart';

class MockGetPrograms extends Mock implements GetPrograms {}

class FakeProgramEntity extends Mock implements ProgramEntity {}

void main() {
  late ProgramsStore store;
  late MockGetPrograms usecase;
  late LoadedUtils<List<FakeProgramEntity>> loadedUtils;
  final someFailure = ServerFailure();
  final programs = [FakeProgramEntity()];

  setUp(() {
    usecase = MockGetPrograms();
    loadedUtils = LoadedUtils<List<FakeProgramEntity>>();
    store = ProgramsStore(usecase);
  });

  group('load entity', () {
    _test(LoadStates state) async {
      final loadedResult = loadedUtils.returnResult(state: state, entity: programs, someFailure: someFailure);
      when(() => usecase.call()).thenAnswer((_) async {
        expect(store.loading, true);
        return loadedResult;
      });
      await store.loadEntity();
      expect(state == LoadStates.failed ? Left(store.failureType) : Right(store.entity), loadedResult);
      verify(() => usecase.call()).called(1);
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
