import 'package:flutter/material.dart';
import 'package:insight/core/builders/entity_builder.dart';
import 'package:insight/features/courses_preview/presentation/screens/states/programs_screen_loaded.dart';
import 'package:insight/features/courses_preview/presentation/store/courses_preview_store.dart';
import 'package:insight/services/di/locator_service.dart';
import 'package:provider/provider.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({Key? key}) : super(key: key);

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final programsStore = getIt.get<CoursesPreviewStore>();

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
      body: Provider<CoursesPreviewStore>(
        create: (context) => programsStore,
        builder: (context, _) {
          return const EntityBuilder<CoursesPreviewStore>(
            loadedWidget: ProgramsScreenLoaded(),
          );
        },
      ),
    );
  }
}
