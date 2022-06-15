import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';

part 'program_model.freezed.dart';
part 'program_model.g.dart';

@freezed
class ProgramModel extends ProgramEntity with _$ProgramModel {
  const factory ProgramModel({
    required int id,
    required String name,
    required String imageUrl,
  }) = _ProgramModel;

  factory ProgramModel.fromJson(Map<String, Object?> json) => _$ProgramModelFromJson(json);
}
