import 'package:dartz/dartz.dart';
import 'package:insight/common/models/failure.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
