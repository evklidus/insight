import 'package:m_sport/core/errors/exceptions.dart';
import 'package:m_sport/features/programs/data/datasources/remote_datasource.dart';
import 'package:m_sport/features/programs/domain/repositories/programs_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/services/http/network_info.dart';

class ProgramsRepositoryImpl implements ProgramsRepository {
  final ProgramsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProgramsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  getPrograms() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getPrograms();
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
