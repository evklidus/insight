import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/exceptions.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/features/categories/domain/repositories/categories_repository.dart';
import 'package:insight/services/http/network_info.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final NetworkInfo netforkInfo;
  final CategoriesRemoteDataSource categoriesRemoteDataSource;

  CategoriesRepositoryImpl({
    required this.netforkInfo,
    required this.categoriesRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>?>> getCategories() async {
    if (await netforkInfo.isConnected) {
      try {
        final categories = await categoriesRemoteDataSource.getCategories();
        return Right(categories);
      } on ServerException {
        return Left(ServerFailure());
      } catch (error) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConntectionFailure());
    }
  }
}
