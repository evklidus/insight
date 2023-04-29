import 'package:insight/common/http/network_info.dart';
import 'package:insight/common/models/exceptions.dart';
import 'package:insight/common/models/failure.dart';
import 'package:insight/features/course_previews/data/datasources/course_previews_remote_datasource.dart';
import 'package:insight/features/course_previews/domain/entities/course_preview_entity.dart';
import 'package:insight/features/course_previews/domain/repositories/courses_preview_repository.dart';
import 'package:dartz/dartz.dart';

class CoursesPreviewRepositoryImpl implements CoursesPreviewRepository {
  final CoursePreviewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CoursesPreviewRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CoursePreviewEntity>>> getCoursesPreview(
    String categoryTag,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.getCoursePreviews(categoryTag);
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
