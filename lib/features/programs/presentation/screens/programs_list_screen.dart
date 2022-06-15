import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:m_sport/features/programs/presentation/widgets/program_widget.dart';
import 'package:m_sport/features/programs/presentation/store/programs_store.dart';
import 'package:m_sport/services/di/locator_service.dart';
import 'package:provider/provider.dart';

class ProgramsListScreen extends StatefulWidget {
  const ProgramsListScreen({Key? key}) : super(key: key);

  @override
  State<ProgramsListScreen> createState() => _ProgramsListScreenState();
}

class _ProgramsListScreenState extends State<ProgramsListScreen> {
  final programsStore = getIt.get<ProgramsStore>();

  @override
  void initState() {
    programsStore.fetchPrograms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (BuildContext context) => programsStore,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Minasov_Sport'),
          ),
          body: Observer(builder: (context) {
            if (programsStore.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (programsStore.error) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (programsStore.programs != null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: programsStore.programs!
                      .map(
                        (program) => ProgramWidget(program: program),
                      )
                      .toList(),
                ),
              );
            }
            return Container();
          }),
        ));
  }
}
