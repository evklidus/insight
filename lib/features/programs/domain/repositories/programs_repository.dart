import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';

abstract class ProgramsRepository {
  Future<Either<Failure, List<ProgramEntity>?>> getPrograms();
}
