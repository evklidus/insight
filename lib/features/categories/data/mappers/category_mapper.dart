import 'package:insight/features/categories/data/entities/category_entity.dart';
import 'package:rest_client/rest_client.dart';

extension CategoryMapper on CategoryDTO {
  CategoryEntity toEntity() {
    return CategoryEntity(
      name: name,
      imageUrl: imageUrl,
      tag: tag,
    );
  }
}
