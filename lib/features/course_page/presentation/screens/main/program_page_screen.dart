import 'package:flutter/material.dart';
import 'package:insight/components/boxes/h_box.dart';
import 'package:insight/core/builders/entity_builder.dart';
import 'package:insight/core/constants/color_constants.dart';
import 'package:insight/features/courses_preview/presentation/screens/states/program_page_screen_loaded.dart';
import 'package:insight/features/courses/presentation/widgets/program_page_screen_title.dart';
import 'package:insight/features/courses_preview/domain/entities/course_preview_entity.dart';
import 'package:insight/features/courses_preview/presentation/store/program_page_store.dart';
import 'package:insight/services/di/locator_service.dart';
import 'package:insight/utilities/load_states.dart';
import 'package:provider/provider.dart';

class ProgramPageScreen extends StatefulWidget {
  const ProgramPageScreen({Key? key, required this.program}) : super(key: key);

  final ProgramEntity program;

  @override
  State<ProgramPageScreen> createState() => _ProgramPageScreenState();
}

class _ProgramPageScreenState extends State<ProgramPageScreen> {
  final programPageStore = getIt.get<ProgramPageStore>();

  @override
  void initState() {
    programPageStore.loadPragramPage(widget.program.id);
    programPageStore.loadState = LoadStates.loading;
    programPageStore.reloadFunc =
        () => programPageStore.loadPragramPage(widget.program.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: ColorConstants.programPageGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                ProgramPageScreenTitle(widget.program),
                const HBox(25),
                Provider<ProgramPageStore>(
                  create: (context) => programPageStore,
                  builder: (context, _) {
                    return const Expanded(
                      child: EntityBuilder<ProgramPageStore>(
                        loadedWidget: ProgramPageScreenLoaded(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
