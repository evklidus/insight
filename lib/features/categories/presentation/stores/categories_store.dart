import 'package:insight/core/stores/entity_store.dart';
import 'package:insight/core/stores/load_params.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/features/categories/domain/usecases/get_categories.dart';
import 'package:mobx/mobx.dart';

part 'categories_store.g.dart';

class CategoriesStore = _CategoriesStore with _$CategoriesStore;

abstract class _CategoriesStore extends EntityStore<List<CategoryEntity>>
    with Store {
  final GetCategories getCategories;

  _CategoriesStore(this.getCategories);

  @override
  fetchEntity([LoadParams? params]) {
    return getCategories();
  }
}
