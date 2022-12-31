import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/courses_preview/domain/entities/course_preview_entity.dart';
import 'package:insight/features/courses_preview/domain/usecases/get_courses_preview_.dart';
import 'package:insight/features/courses_preview/presentation/store/courses_preview_store.dart';
import 'package:insight/utilities/load_states.dart';
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
      final loadedResult = loadedUtils.returnResult(
          state: state, entity: programs, someFailure: someFailure);
      when(() => usecase.call()).thenAnswer((_) async {
        expect(store.loadState, LoadStates.loading);
        return loadedResult;
      });
      await store.loadEntity();
      expect(
          state == LoadStates.failed
              ? Left(store.failureType)
              : Right(store.entity),
          loadedResult);
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
