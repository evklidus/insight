import 'package:flutter/material.dart';
import 'package:m_sport/core/builders/entity_builder.dart';
import 'package:m_sport/features/programs/presentation/screens/states/programs_screen_loaded.dart';
import 'package:m_sport/features/programs/presentation/store/programs_store.dart';
import 'package:m_sport/services/di/locator_service.dart';
import 'package:provider/provider.dart';

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
    // programsStore.reloadFunc = () {
    //   programsStore.loadEntity();
    // };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minasov_Sport'),
      ),
      body: Provider<ProgramsStore>(
        create: (context) => programsStore,
        builder: (context, _) {
          return const EntityBuilder<ProgramsStore>(
            loadedWidget: ProgramsScreenLoaded(),
          );
        },
      ),
    );
  }
}
