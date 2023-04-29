import 'package:dartz/dartz.dart';
import 'package:insight/common/http/network_info.dart';
import 'package:insight/common/models/exceptions.dart';
import 'package:insight/common/models/failure.dart';
import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/features/categories/domain/repositories/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final NetworkInfo networkInfo;
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriesRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
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
