import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/courses_/domain/entities/program_page_entity.dart';
import 'package:insight/features/courses_preview/domain/usecases/get_program_page.dart';
import 'package:insight/features/courses_preview/presentation/store/program_page_store.dart';
import 'package:insight/utilities/load_states.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utilities/loaded_utilities.dart';

class MockGetProgramPage extends Mock implements GetProgramPage {}

class FakeProgramPageEntity extends Mock implements ProgramPageEntity {}

void main() {
  late ProgramPageStore store;
  late GetProgramPage usecase;
  late LoadedUtils<ProgramPageEntity> loadedUtils;
  final someFailure = ServerFailure();
  const programPageId = 1;
  final programPageParams = ProgramPageParams(id: programPageId);
  final programPage = FakeProgramPageEntity();

  setUp(() {
    usecase = MockGetProgramPage();
    loadedUtils = LoadedUtils<ProgramPageEntity>();
    store = ProgramPageStore(usecase);
    registerFallbackValue(programPageParams);
  });

  group('load entity', () {
    _test(LoadStates state) async {
      final loadedResult = loadedUtils.returnResult(
          state: state, entity: programPage, someFailure: someFailure);
      when(() => usecase.call(any<ProgramPageParams>())).thenAnswer((_) async {
        expect(store.loadState, LoadStates.loading);
        return loadedResult;
      });
      await store.loadPragramPage(programPageId);
      expect(
          state == LoadStates.failed
              ? Left(store.failureType)
              : Right(store.entity),
          loadedResult);
      verify(() => usecase.call(any<ProgramPageParams>())).called(1);
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
