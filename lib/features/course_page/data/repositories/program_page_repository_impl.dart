import 'package:insight/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/courses_preview/data/datasources/program_page_remote_datasource.dart';
import 'package:insight/features/courses_/domain/entities/program_page_entity.dart';
import 'package:insight/features/courses_preview/domain/repositories/program_page_repository.dart';
import 'package:insight/services/http/network_info.dart';

class ProgramPageRepositoryImpl implements ProgramPageRepository {
  final ProgramPageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProgramPageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  getProgramPage(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final ProgramPageEntity? remoteData =
            await remoteDataSource.getProgramPage(id);
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
