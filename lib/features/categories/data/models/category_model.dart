import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel extends CategoryEntity with _$CategoryModel {
  const factory CategoryModel({
    required String name,
    required String tag,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, Object?> json) =>
      _$CategoryModelFromJson(json);
}
