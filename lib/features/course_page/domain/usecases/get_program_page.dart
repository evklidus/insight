import 'package:insight/core/usecases/usecase.dart';
import 'package:insight/features/courses_/domain/entities/program_page_entity.dart';
import 'package:insight/features/courses_preview/domain/repositories/program_page_repository.dart';

class GetProgramPage
    extends UseCaseWithParams<ProgramPageEntity?, ProgramPageParams> {
  final ProgramPageRepository repository;

  GetProgramPage(this.repository);

  @override
  call(ProgramPageParams params) {
    final programPage = repository.getProgramPage(params.id);
    return programPage;
  }
}

class ProgramPageParams {
  final int id;
  ProgramPageParams({required this.id});
}
