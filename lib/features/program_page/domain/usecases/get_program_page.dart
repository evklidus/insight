import 'package:m_sport/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:m_sport/core/usecases/usecase.dart';
import 'package:m_sport/features/program_page/domain/entities/program_page_entity.dart';
import 'package:m_sport/features/program_page/domain/repositories/program_page_repository.dart';

class GetProgramPage extends UseCaseWithParams<ProgramPageEntity, ProgramPageParams> {
  final ProgramPageRepository repository;

  GetProgramPage(this.repository);

  @override
  Future<Either<Failure, ProgramPageEntity>> call(ProgramPageParams params) {
    final programPage = repository.getProgramPage(params.id);
    return programPage;
  }
}

class ProgramPageParams {
  final int id;
  ProgramPageParams({required this.id});
}
