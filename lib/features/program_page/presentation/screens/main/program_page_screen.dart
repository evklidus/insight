import 'package:flutter/material.dart';
import 'package:m_sport/components/boxes/h_box.dart';
import 'package:m_sport/core/builders/entity_builder.dart';
import 'package:m_sport/core/constants/color_constants.dart';
import 'package:m_sport/features/program_page/presentation/screens/states/program_page_screen_loaded.dart';
import 'package:m_sport/features/program_page/presentation/widgets/program_page_screen_title.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/features/program_page/presentation/store/program_page_store.dart';
import 'package:m_sport/services/di/locator_service.dart';
import 'package:m_sport/utilities/load_states.dart';
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
    programPageStore.reloadFunc = () => programPageStore.loadPragramPage(widget.program.id);
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
