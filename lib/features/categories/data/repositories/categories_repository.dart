import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/data/entities/category_entity.dart';
import 'package:insight/features/categories/data/mappers/category_mapper.dart';

abstract class CategoriesRepository {
  Future<List<CategoryEntity>> getCategories();
}

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categories = await remoteDataSource.getCategories();
    return categories.map((e) => e.toEntity()).toList();
  }
}
