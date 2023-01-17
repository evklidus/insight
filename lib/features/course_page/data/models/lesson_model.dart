import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/features/course_page/domain/entities/lesson_entity.dart';
import 'package:flutter/foundation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
// @JsonSerializable(explicitToJson: true)
class LessonModel extends LessonEntity with _$LessonModel {
  const factory LessonModel({
    required String name,
    required String videoUrl,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, Object?> json) =>
      _$LessonModelFromJson(json);
}
