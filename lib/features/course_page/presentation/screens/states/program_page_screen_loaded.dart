import 'package:flutter/material.dart';
import 'package:insight/features/courses_preview/presentation/store/program_page_store.dart';
import 'package:insight/features/courses_/presentation/widgets/training_view.dart';
import 'package:provider/provider.dart';

class ProgramPageScreenLoaded extends StatelessWidget {
  const ProgramPageScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<ProgramPageStore>();
    return Column(
      children: store.entity!.trainings
          .map(
            (training) => TrainingView(
              training: training,
            ),
          )
          .toList(),
    );
  }
}
