import 'package:flutter/material.dart';
import 'package:insight/core/builders/entity_builder.dart';
import 'package:insight/features/programs/presentation/screens/states/programs_screen_loaded.dart';
import 'package:insight/features/programs/presentation/store/programs_store.dart';
import 'package:insight/services/di/locator_service.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insight'),
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
