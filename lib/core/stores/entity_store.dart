import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/core/stores/load_params.dart';
import 'package:mobx/mobx.dart';

part 'entity_store.g.dart';

abstract class EntityStore<T> = _EntityStore<T> with _$EntityStore;

abstract class _EntityStore<T> with Store {
  @computed
  bool get loaded => !loading && entity != null;

  @computed
  bool get empty => (entity == null ? true : false) && !failure;

  @observable
  bool loading = false;

  @observable
  bool failure = false;

  @observable
  Failure failureType = ServerFailure();

  @observable
  T? entity;

  void setEntity(T? entity) {
    this.entity = entity;
  }

  void _setFailure(Failure failure) {
    this.failure = true;
    failureType = failure;
  }

  Future<Either<Failure, T?>> fetchEntity([LoadParams? params]);

  @action
  Future<void> loadEntity([LoadParams? params]) async {
    loading = true;
    final resultOrFailure = await fetchEntity(params);
    resultOrFailure.fold(
      (failure) {
        _setFailure(failure);
      },
      (entity) {
        setEntity(entity);
      },
    );
    loading = false;
  }

  Future<T?> getEntity([LoadParams? params]) async {
    // use only in store
    // after use it you have to set entity with setEntity func
    loading = true;
    T? returnedEntity;
    final resultOrFailure = await fetchEntity(params);
    resultOrFailure.fold(
      (failure) {
        _setFailure(failure);
      },
      (entity) {
        returnedEntity = entity;
      },
    );
    loading = false;
    return returnedEntity;
  }
}
