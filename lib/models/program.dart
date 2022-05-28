import 'package:m_sport/models/training.dart';

class Program {
  final String name;
  final String imageUrl;
  final List<Training> trainings;

  Program({
    required this.name,
    required this.imageUrl,
    required this.trainings,
  });
}
