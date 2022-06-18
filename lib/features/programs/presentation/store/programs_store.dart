import 'package:m_sport/core/stores/entity_store.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/features/programs/domain/usecases/get_programs.dart';
import 'package:mobx/mobx.dart';

part 'programs_store.g.dart';

class ProgramsStore = _ProgramsStore with _$ProgramsStore;

abstract class _ProgramsStore extends EntityStore<List<ProgramEntity>> with Store {
  final GetPrograms getPrograms;

  _ProgramsStore(this.getPrograms);

  @override
  fetchEntity([LoadParams? params]) {
    return getPrograms();
  }
}
