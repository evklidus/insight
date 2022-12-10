import 'package:insight/core/usecases/usecase.dart';
import 'package:insight/features/programs/domain/entities/program_entity.dart';
import 'package:insight/features/programs/domain/repositories/programs_repository.dart';

class GetPrograms extends UseCase<List<ProgramEntity>?> {
  final ProgramsRepository programsRepository;

  GetPrograms(this.programsRepository);

  @override
  call() async {
    return await programsRepository.getPrograms();
  }
}
