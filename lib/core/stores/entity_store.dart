import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/core/stores/load_params.dart';
import 'package:insight/utilities/load_states.dart';
import 'package:mobx/mobx.dart';

part 'entity_store.g.dart';

// Because it's standartmobx constuction, make with constructor is too large
// ignore: library_private_types_in_public_api
abstract class EntityStore<T> = _EntityStore<T> with _$EntityStore;

abstract class _EntityStore<T> with Store {
  @observable
  LoadStates loadState = LoadStates.empty;

  @observable
  Failure failureType = ServerFailure();

  @observable
  T? entity;

  void setEntity(T? entity) {
    loadState = entity == null ? LoadStates.empty : LoadStates.successful;
    this.entity = entity;
  }

  void _setFailure(Failure failure) {
    loadState = LoadStates.failed;
    failureType = failure;
  }

  // Must to define reloadFunc on setState. Reload button will not show if it not define
  Future<void> Function()? reloadFunc;

  Future<Either<Failure, T?>> fetchEntity([LoadParams? params]);

  // MobX not correctly notify about changes if func has await statement. This code 'hacking' this error
  Future<Type> asyncAction<Type>(Future<Type> Function() function) =>
      function();

  @action
  Future<void> loadEntity([LoadParams? params]) => asyncAction<void>(() async {
        loadState = LoadStates.loading;
        await Future.delayed(const Duration(milliseconds: 500), () async {
          final resultOrFailure = await fetchEntity(params);
          resultOrFailure.fold(
            (failure) {
              _setFailure(failure);
            },
            (entity) {
              setEntity(entity);
            },
          );
        });
      });

  Future<T?> getEntity([LoadParams? params]) => asyncAction<T?>(() async {
        // use only in store
        // after use it you have to set entity with setEntity func
        loadState = LoadStates.loading;
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
        loadState = LoadStates.successful;
        return returnedEntity;
      });
}
