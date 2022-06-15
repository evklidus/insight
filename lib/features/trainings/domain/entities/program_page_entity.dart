import 'package:m_sport/features/trainings/domain/entities/training_entity.dart';

class ProgramPageEntity {
  final int id;
  final List<TrainingEntity> trainings;

  ProgramPageEntity({
    required this.id,
    required this.trainings,
  });
}
