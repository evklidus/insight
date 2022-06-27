import 'package:flutter_test/flutter_test.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/features/programs/domain/repositories/programs_repository.dart';
import 'package:m_sport/features/programs/domain/usecases/get_programs.dart';
import 'package:mocktail/mocktail.dart';

import '../../utilities/loaded_utilities.dart';

class MockProgramsRepository extends Mock implements ProgramsRepository {}

class FakeProgramEntity extends Fake implements ProgramEntity {}

void main() {
  late GetPrograms usecase;
  late MockProgramsRepository repository;
  late Failure someFailure;
  late LoadedUtils<List<FakeProgramEntity>> loadedUtils;
  final programs = [FakeProgramEntity()];

  setUp(() {
    repository = MockProgramsRepository();
    usecase = GetPrograms(repository);
    someFailure = ServerFailure();
    loadedUtils = LoadedUtils<List<FakeProgramEntity>>();
    reset(repository);
  });

  group('load', () {
    _test(LoadStates state) async {
      final loadedResult = loadedUtils.returnResult(state: state, entity: programs, someFailure: someFailure);
      when(() => repository.getPrograms()).thenAnswer((_) async => loadedResult);
      final result = await usecase.call();
      expect(result, loadedResult);
      verify(() => repository.getPrograms()).called(1);
      verifyNoMoreInteractions(repository);
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
