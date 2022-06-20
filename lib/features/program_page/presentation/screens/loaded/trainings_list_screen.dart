import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:m_sport/components/boxes.dart';
import 'package:m_sport/core/constants/color_constants.dart';
import 'package:m_sport/features/program_page/presentation/screens/others/training_list_screen_empty.dart';
import 'package:m_sport/features/program_page/presentation/screens/others/training_list_screen_failure.dart';
import 'package:m_sport/features/program_page/presentation/screens/others/training_list_screen_loading.dart';
import 'package:m_sport/features/program_page/presentation/widgets/training_view.dart';
import 'package:m_sport/features/program_page/presentation/widgets/trainings_list_screen_title.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/features/program_page/presentation/store/program_page_store.dart';
import 'package:m_sport/services/di/locator_service.dart';

class TrainingsListScreen extends StatefulWidget {
  const TrainingsListScreen({Key? key, required this.program}) : super(key: key);

  final ProgramEntity program;

  @override
  State<TrainingsListScreen> createState() => _TrainingsListScreenState();
}

class _TrainingsListScreenState extends State<TrainingsListScreen> {
  final programPageStore = getIt.get<ProgramPageStore>();

  @override
  void initState() {
    programPageStore.loadPragramPage(widget.program.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: ColorConstants.programPageGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                TrainingsListScreenTitle(widget.program),
                const HBox(25),
                Observer(builder: (context) {
                  if (programPageStore.loading) {
                    return const TrainingListScreenLoading();
                  }
                  if (programPageStore.failure) {
                    return const TrainingListScreenFailure();
                  }
                  if (programPageStore.empty) {
                    return const TrainingListScreenEmpty();
                  }
                  if (programPageStore.loaded) {
                    return Column(
                      children: programPageStore.entity!.trainings
                          .map(
                            (training) => TrainingView(
                              training: training,
                            ),
                          )
                          .toList(),
                    );
                  }
                  return Container();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
