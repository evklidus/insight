import 'package:dartz/dartz.dart';
import 'package:m_sport/core/errors/failure.dart';
import 'package:m_sport/core/usecases/usecase.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/features/programs/domain/repositories/programs_repository.dart';

class GetPrograms extends UseCase<List<ProgramEntity>> {
  final ProgramsRepository programsRepository;

  GetPrograms({
    required this.programsRepository,
  });

  @override
  Future<Either<Failure, List<ProgramEntity>>> call() async {
    return await programsRepository.getPrograms();
  }
}
