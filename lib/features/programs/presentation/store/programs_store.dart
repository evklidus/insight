import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/features/programs/domain/usecases/get_programs.dart';
import 'package:mobx/mobx.dart';

part 'programs_store.g.dart';

class ProgramsStore = _ProgramsStore with _$ProgramsStore;

abstract class _ProgramsStore with Store {
  final GetPrograms getPrograms;

  _ProgramsStore(this.getPrograms);

  @observable
  bool loading = false;

  @observable
  bool error = false;

  @observable
  List<ProgramEntity>? programs;

  @action
  Future<void> fetchPrograms() async {
    loading = true;
    final failureOrPrograms = await getPrograms();
    failureOrPrograms.fold(
      (failure) => error = true,
      (programs) => this.programs = programs,
    );
    loading = false;
  }
}
