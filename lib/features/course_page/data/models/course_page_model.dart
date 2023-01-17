import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/features/course_page/data/models/lesson_model.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';
import 'package:flutter/foundation.dart';

part 'course_page_model.freezed.dart';
part 'course_page_model.g.dart';

@freezed
// @JsonSerializable(explicitToJson: true)
class CoursePageModel extends CoursePageEntity with _$CoursePageModel {
  const factory CoursePageModel({
    required int id,
    required List<LessonModel> lessons,
  }) = _CoursePageModel;

  factory CoursePageModel.fromJson(Map<String, Object?> json) =>
      _$CoursePageModelFromJson(json);
}
