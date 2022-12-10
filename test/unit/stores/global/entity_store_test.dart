import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/core/stores/entity_store.dart';
import 'package:insight/core/stores/load_params.dart';
import 'package:insight/utilities/load_states.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utilities/loaded_utilities.dart';

class _EntityStore extends EntityStore<FakeEntity> with Mock {}

class FakeEntity extends Fake {}

void main() {
  late _EntityStore store;
  late LoadedUtils<FakeEntity> loadedUtils;
  final someFailure = ServerFailure();
  final programPage = FakeEntity();
  const loadParams = LoadParams({'id': 1});

  setUp(() {
    store = _EntityStore();
    loadedUtils = LoadedUtils<FakeEntity>();
    registerFallbackValue(loadParams);
  });

  group('load entity', () {
    _test(LoadStates state) async {
      final loadedResult = loadedUtils.returnResult(
          state: state, entity: programPage, someFailure: someFailure);
      when(() => store.fetchEntity(any<LoadParams>())).thenAnswer((_) async {
        expect(store.loadState, LoadStates.loading);
        return loadedResult;
      });
      await store.loadEntity();
      switch (state) {
        case LoadStates.successful:
          expect(Right(store.entity), loadedResult);
          break;
        case LoadStates.failed:
          expect(Left(store.failureType), loadedResult);
          break;
        case LoadStates.empty:
          expect(const Right(null), loadedResult);
          break;
        default:
          break;
      }
      verify(() => store.fetchEntity(any<LoadParams>())).called(1);
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

  group('get entity', () {
    _test(LoadStates state) async {
      final loadedResult = loadedUtils.returnResult(
          state: state, entity: programPage, someFailure: someFailure);
      when(() => store.fetchEntity()).thenAnswer((_) async {
        expect(store.loadState, LoadStates.loading);
        return loadedResult;
      });
      final result = await store.getEntity();
      store.setEntity(result);
      switch (state) {
        case LoadStates.successful:
          expect(Right(store.entity), loadedResult);
          break;
        case LoadStates.failed:
          expect(Left(store.failureType), loadedResult);
          break;
        case LoadStates.empty:
          expect(const Right(null), loadedResult);
          break;
        default:
          break;
      }
      verify(() => store.fetchEntity()).called(1);
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
