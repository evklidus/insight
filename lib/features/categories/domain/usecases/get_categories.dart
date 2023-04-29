import 'package:insight/core/usecases/usecase.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/features/categories/domain/repositories/categories_repository.dart';

class GetCategories extends UseCase<List<CategoryEntity>> {
  final CategoriesRepository categoriesRepository;
  GetCategories(this.categoriesRepository);

  @override
  call() async {
    final categories = await categoriesRepository.getCategories();
    return categories;
  }
}
