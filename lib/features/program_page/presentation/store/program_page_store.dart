import 'package:insight/core/stores/load_params.dart';
import 'package:insight/features/program_page/domain/entities/program_page_entity.dart';
import 'package:insight/features/program_page/domain/usecases/get_program_page.dart';
import 'package:insight/core/stores/entity_store.dart';
import 'package:mobx/mobx.dart';

part 'program_page_store.g.dart';

class ProgramPageStore = _ProgramPageStore with _$ProgramPageStore;

abstract class _ProgramPageStore extends EntityStore<ProgramPageEntity>
    with Store {
  final GetProgramPage getProgramPage;

  _ProgramPageStore(this.getProgramPage);

  @override
  fetchEntity([LoadParams? params]) {
    return getProgramPage(ProgramPageParams(id: params?.params!['id'] as int));
  }

  Future<void> loadPragramPage(int id) async {
    await loadEntity(LoadParams({'id': id}));
  }
}
