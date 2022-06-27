import 'package:equatable/equatable.dart';

abstract class Failure {}

class ServerFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class InternetConntectionFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}
