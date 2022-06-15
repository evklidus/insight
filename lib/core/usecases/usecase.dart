import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';

abstract class UseCase<Type> {
  Future<Either<Failure, Type>> call();
}
