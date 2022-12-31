import 'package:insight/core/errors/exceptions.dart';
import 'package:insight/features/courses_preview/data/datasources/courses_preview_remote_datasource.dart';
import 'package:insight/features/courses_preview/domain/entities/course_preview_entity.dart';
import 'package:insight/features/courses_preview/domain/repositories/courses_preview_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/services/http/network_info.dart';

class CoursesPreviewRepositoryImpl implements CoursesPreviewRepository {
  final CoursesPreviewRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CoursesPreviewRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CoursePreviewEntity>?>> getCoursesPreview(
      String categoryTag) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.getCoursesPreview(categoryTag);
        return Right(remoteData);
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
