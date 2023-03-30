import 'package:insight/core/stores/load_params.dart';
import 'package:insight/core/stores/entity_store.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';
import 'package:insight/features/course_page/domain/usecases/get_course_page.dart';
import 'package:mobx/mobx.dart';

part 'course_page_store.g.dart';

// Because it's standartmobx constuction, make with constructor is too large
// ignore: library_private_types_in_public_api
class CoursePageStore = _CoursePageStore with _$CoursePageStore;

abstract class _CoursePageStore extends EntityStore<CoursePageEntity>
    with Store {
  final GetCoursePage getCoursePage;

  _CoursePageStore(this.getCoursePage);

  @override
  fetchEntity([LoadParams? params]) {
    return getCoursePage(CoursePageParams(id: params?.params!['id'] as int));
  }

  @action
  Future<void> loadCoursePage(int id) async {
    await loadEntity(LoadParams({'id': id}));
  }
}
