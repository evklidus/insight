import 'package:insight/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/course_page/data/datasources/course_page_remote_datasource.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';
import 'package:insight/features/course_page/domain/repositories/course_page_repository.dart';
import 'package:insight/services/http/network_info.dart';

class CoursePageRepositoryImpl implements CoursePageRepository {
  final CoursePageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CoursePageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  getCoursePage(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final CoursePageEntity? remoteData =
            await remoteDataSource.getCoursePage(id);
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
