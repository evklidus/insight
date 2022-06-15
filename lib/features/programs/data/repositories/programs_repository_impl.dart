import 'package:m_sport/core/errors/exceptions.dart';
import 'package:m_sport/features/programs/data/datasources/remote_datasource.dart';
import 'package:m_sport/features/programs/data/models/program_model.dart';
import 'package:m_sport/features/programs/domain/repositories/programs_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/services/http/network_info.dart';

class ProgramsRepositoryImpl implements ProgramsRepository {
  final ProgramsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProgramsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProgramEntity>>> getPrograms() async {
    if (await networkInfo.isConnected) {
      try {
        final List<ProgramModel> remoteData = await remoteDataSource.getPrograms();
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
