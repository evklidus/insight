import 'package:flutter/material.dart';
import 'package:m_sport/components/program_widget.dart';
import 'package:m_sport/data.dart';
import 'package:m_sport/models/program.dart';

class ProgramsListScreen extends StatelessWidget {
  const ProgramsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Program> programs = Data().programs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minasov_Sport'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          children: programs
              .map(
                (program) => ProgramWidget(program: program),
              )
              .toList(),
        ),
      ),
    );
  }
}
