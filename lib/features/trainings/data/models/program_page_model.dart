import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:m_sport/features/trainings/data/models/training_model.dart';
import 'package:m_sport/features/trainings/domain/entities/program_page_entity.dart';
import 'package:flutter/foundation.dart';

part 'program_page_model.freezed.dart';
part 'program_page_model.g.dart';

@freezed
class ProgramPageModel extends ProgramPageEntity with _$ProgramPageModel {
  const factory ProgramPageModel({
    required int id,
    required List<TrainingModel> trainings,
  }) = _ProgramPageModel;

  factory ProgramPageModel.fromJson(Map<String, Object?> json) => _$ProgramPageModelFromJson(json);
}
