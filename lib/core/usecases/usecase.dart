import 'package:dartz/dartz.dart';
import 'package:insight/common/models/failure.dart';

abstract class UseCase<Type> {
  Future<Either<Failure, Type>> call();
}

abstract class UseCaseWithParams<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
