import 'package:flutter_test/flutter_test.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/features/program_page/domain/entities/program_page_entity.dart';
import 'package:m_sport/features/program_page/domain/repositories/program_page_repository.dart';
import 'package:m_sport/features/program_page/domain/usecases/get_program_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../utilities/loaded_utilities.dart';

class MockProgramPageRepository extends Mock implements ProgramPageRepository {}

class FakeProgramPageEntity extends Fake implements ProgramPageEntity {}

void main() {
  late GetProgramPage usecase;
  late MockProgramPageRepository repository;
  late Failure someFailure;
  late LoadedUtils<ProgramPageEntity> loadedUtils;
  const programPageId = 1;
  final programPageParams = ProgramPageParams(id: programPageId);
  final programPage = FakeProgramPageEntity();

  setUp(() {
    repository = MockProgramPageRepository();
    usecase = GetProgramPage(repository);
    someFailure = ServerFailure();
    loadedUtils = LoadedUtils<FakeProgramPageEntity>();
    reset(repository);
  });

  group('load', () {
    _test(LoadStates state) async {
      final loadedResult = loadedUtils.returnResult(state: state, entity: programPage, someFailure: someFailure);
      when(() => repository.getProgramPage(programPageId)).thenAnswer((_) async => loadedResult);
      final result = await usecase.call(programPageParams);
      expect(result, loadedResult);
      verify(() => repository.getProgramPage(programPageId)).called(1);
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
