import 'package:flutter/material.dart';
import 'package:m_sport/features/programs/presentation/store/programs_store.dart';
import 'package:m_sport/features/programs/presentation/widgets/program_widget.dart';
import 'package:provider/provider.dart';

class ProgramsScreenLoaded extends StatelessWidget {
  const ProgramsScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<ProgramsStore>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: store.entity!
            .map(
              (program) => ProgramWidget(program: program),
            )
            .toList(),
      ),
    );
  }
}
