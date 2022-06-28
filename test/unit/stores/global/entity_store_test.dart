import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/core/stores/entity_store.dart';
import 'package:m_sport/core/stores/load_params.dart';
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
      final loadedResult = loadedUtils.returnResult(state: state, entity: programPage, someFailure: someFailure);
      when(() => store.fetchEntity(any<LoadParams>())).thenAnswer((_) async {
        expect(store.loading, true);
        return loadedResult;
      });
      await store.loadEntity();
      expect(state == LoadStates.failed ? Left(store.failureType) : Right(store.entity), loadedResult);
      expect(store.loading, false);
      expect(store.loaded, state == LoadStates.empty || state == LoadStates.failed ? false : true);
      expect(store.empty, state == LoadStates.empty ? true : false);
      expect(store.failure, state == LoadStates.failed ? true : false);
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
      final loadedResult = loadedUtils.returnResult(state: state, entity: programPage, someFailure: someFailure);
      when(() => store.fetchEntity()).thenAnswer((_) async {
        expect(store.loading, true);
        return loadedResult;
      });
      final result = await store.getEntity();
      store.setEntity(result);
      expect(state == LoadStates.failed ? Left(store.failureType) : Right(result), loadedResult);
      expect(store.loading, false);
      expect(store.loaded, state == LoadStates.empty || state == LoadStates.failed ? false : true);
      expect(store.empty, state == LoadStates.empty ? true : false);
      expect(store.failure, state == LoadStates.failed ? true : false);
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
