import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:mobx/mobx.dart';

part 'entity_store.g.dart';

abstract class EntityStore<T> = _EntityStore<T> with _$EntityStore;

abstract class _EntityStore<T> with Store {
  @computed
  bool get loaded => loading != true && entity != null;

  @computed
  bool get empty {
    if (T is List<Object>) {
      final entityList = entity as List<Object>;
      entityList.isEmpty ? true : false;
    }
    return false;
  }

  @observable
  bool loading = false;

  @observable
  bool failure = false;

  @observable
  Failure failureType = ServerFailure();

  @observable
  T? entity;

  void _setEntity(T entity) {
    this.entity = entity;
  }

  void _setFailure(Failure failure) {
    this.failure = true;
    failureType = failure;
  }

  Future<Either<Failure, T>> fetchEntity([LoadParams? params]);

  @action
  Future<void> loadEntity([LoadParams? params]) async {
    loading = true;
    final Either<Failure, T> resultOrFailure = await fetchEntity(params);
    resultOrFailure.fold(
      (failure) {
        _setFailure(failure);
      },
      (entity) {
        _setEntity(entity);
      },
    );
    loading = false;
  }

  Future<T?> getEntity() async {
    // use only in store
    // after use it you have to set entity
    loading = true;
    final Either<Failure, T> resultOrFailure = await fetchEntity();
    resultOrFailure.fold(
      (failure) {
        _setFailure(failure);
      },
      (entity) {
        return entity;
      },
    );
    loading = false;
    return null;
  }
}

class LoadParams {
  final Map<String, Object>? params;
  const LoadParams([this.params]);
}
