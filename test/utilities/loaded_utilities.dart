import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/utilities/load_states.dart';

class LoadedUtils<T> {
  Either<Failure, T?> returnResult({
    required LoadStates state,
    required T entity,
    required Failure someFailure,
  }) {
    switch (state) {
      case LoadStates.successful:
        return Right(entity);
      case LoadStates.failed:
        return Left(someFailure);
      case LoadStates.empty:
        return const Right(null);
      default:
        return const Right(null);
    }
  }

  T? returnForDataSource({
    required LoadStates state,
    required T entity,
  }) {
    switch (state) {
      case LoadStates.successful:
        return entity;
      case LoadStates.failed:
        return null;
      case LoadStates.empty:
        return null;
      default:
        return null;
    }
  }
}
