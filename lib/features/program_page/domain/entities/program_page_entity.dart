import 'package:insight/features/program_page/domain/entities/training_entity.dart';

class ProgramPageEntity {
  final int id;
  final List<TrainingEntity> trainings;

  ProgramPageEntity({
    required this.id,
    required this.trainings,
  });
}
