import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';

enum LoadStates {
  successful,
  failed,
  empty,
}

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
    }
  }
}
