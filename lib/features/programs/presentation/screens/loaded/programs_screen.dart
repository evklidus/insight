import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:m_sport/features/programs/presentation/screens/others/programs_screen_empty.dart';
import 'package:m_sport/features/programs/presentation/screens/others/programs_screen_failure.dart';
import 'package:m_sport/features/programs/presentation/screens/others/programs_screen_loading.dart';
import 'package:m_sport/features/programs/presentation/widgets/program_widget.dart';
import 'package:m_sport/features/programs/presentation/store/programs_store.dart';
import 'package:m_sport/services/di/locator_service.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({Key? key}) : super(key: key);

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final programsStore = getIt.get<ProgramsStore>();

  @override
  void initState() {
    programsStore.loadEntity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minasov_Sport'),
      ),
      body: Observer(builder: (context) {
        if (programsStore.loading) {
          return const ProgramsScreenLoading();
        }
        if (programsStore.failure) {
          return const ProgramsScreenFailure();
        }
        if (programsStore.empty) {
          return const ProgramsScreenEmpty();
        }
        if (programsStore.loaded) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              children: programsStore.entity!
                  .map(
                    (program) => ProgramWidget(program: program),
                  )
                  .toList(),
            ),
          );
        }
        return Container();
      }),
    );
  }
}
