import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:m_sport/features/program_page/domain/entities/training_entity.dart';
import 'package:flutter/foundation.dart';

part 'training_model.freezed.dart';
part 'training_model.g.dart';

@freezed
class TrainingModel extends TrainingEntity with _$TrainingModel {
  const factory TrainingModel({
    required String name,
    required String videoUrl,
  }) = _TrainingModel;

  factory TrainingModel.fromJson(Map<String, Object?> json) => _$TrainingModelFromJson(json);
}
