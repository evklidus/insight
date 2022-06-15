import 'package:m_sport/features/trainings/domain/entities/program_page_entity.dart';
import 'package:m_sport/features/trainings/domain/usecases/get_program_page.dart';
import 'package:mobx/mobx.dart';

part 'program_page_store.g.dart';

class ProgramPageStore = _ProgramPageStore with _$ProgramPageStore;

abstract class _ProgramPageStore with Store {
  final GetProgramPage getProgramPage;

  _ProgramPageStore(this.getProgramPage);

  @observable
  bool loading = false;

  @observable
  bool error = false;

  @observable
  ProgramPageEntity? programPage;

  @action
  Future<void> fetchProgramPage(int id) async {
    loading = true;
    final failureOrProgramPage = await getProgramPage(ProgramPageParams(id: id));
    failureOrProgramPage.fold(
      (failure) => error = true,
      (programPage) => this.programPage = programPage,
    );
    loading = false;
  }
}
