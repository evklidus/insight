import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/features/courses_previews/domain/entities/course_preview_entity.dart';

part 'course_preview_model.freezed.dart';
part 'course_preview_model.g.dart';

@freezed
class CoursePreviewModel extends CoursePreviewEntity with _$CoursePreviewModel {
  const factory CoursePreviewModel({
    required int id,
    required String name,
    required String imageUrl,
    required String tag,
  }) = _CoursePreviewModel;

  factory CoursePreviewModel.fromJson(Map<String, Object?> json) =>
      _$CoursePreviewModelFromJson(json);
}
