import 'package:insight/core/stores/entity_store.dart';
import 'package:insight/core/stores/load_params.dart';
import 'package:insight/features/courses_previews/domain/entities/course_preview_entity.dart';
import 'package:insight/features/courses_previews/domain/usecases/get_courses_preview_.dart';
import 'package:mobx/mobx.dart';

part 'courses_preview_store.g.dart';

// Because it's standartmobx constuction, make with constructor is too large
// ignore: library_private_types_in_public_api
class CoursesPreviewStore = _CoursesPreviewStore with _$CoursesPreviewStore;

abstract class _CoursesPreviewStore
    extends EntityStore<List<CoursePreviewEntity>> with Store {
  final GetCoursesPreview getCoursesPreview;

  _CoursesPreviewStore(this.getCoursesPreview);

  @override
  fetchEntity([LoadParams? params]) {
    return getCoursesPreview(
      CoursesPreviewParams(
        categoryTag: params?.params!['categoryTag'] as String,
      ),
    );
  }

  @action
  loadCoursesPreview(String categoryTag) async {
    await loadEntity(LoadParams({'categoryTag': categoryTag}));
  }
}
