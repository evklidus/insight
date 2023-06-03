import 'package:insight/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/features/categories/domain/repositories/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await remoteDataSource.getCategories();
  }
}
