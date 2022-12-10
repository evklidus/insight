import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/programs/domain/entities/program_entity.dart';

abstract class ProgramsRepository {
  Future<Either<Failure, List<ProgramEntity>?>> getPrograms();
}
