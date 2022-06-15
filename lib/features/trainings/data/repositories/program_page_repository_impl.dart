import 'package:m_sport/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/features/trainings/data/datasources/remote_datasource.dart';
import 'package:m_sport/features/trainings/domain/entities/program_page_entity.dart';
import 'package:m_sport/features/trainings/domain/repositories/program_page_repository.dart';
import 'package:m_sport/services/http/network_info.dart';

class ProgramPageRepositoryImpl implements ProgramPageRepository {
  final ProgramPageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProgramPageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProgramPageEntity>> getProgramPage(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final ProgramPageEntity remoteData = await remoteDataSource.getProgramPage(id);
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
