abstract class UseCase<Type> {
  Future<Type> call();
}

abstract class UseCaseWithParams<Type, Params> {
  Future<Type> call(Params params);
}
