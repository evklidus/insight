import 'package:dartz/dartz.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/program_page/domain/entities/program_page_entity.dart';

abstract class ProgramPageRepository {
  Future<Either<Failure, ProgramPageEntity?>> getProgramPage(int id);
}
