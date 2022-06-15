import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:m_sport/components/boxes.dart';
import 'package:m_sport/components/rounded_back_icon.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/features/program_page/domain/entities/training_entity.dart';
import 'package:m_sport/features/program_page/presentation/store/program_page_store.dart';
import 'package:m_sport/services/di/locator_service.dart';
import 'package:m_sport/services/navigation/app_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
    programPageStore.fetchProgramPage(widget.program.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 77, 19, 87),
              Color.fromARGB(255, 58, 14, 66),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                _Title(widget.program),
                const HBox(25),
                Observer(builder: (context) {
                  if (programPageStore.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (programPageStore.error) {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                  if (programPageStore.programPage != null) {
                    return Column(
                      children: programPageStore.programPage!.trainings
                          .map(
                            (training) => _Training(
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

class _Training extends StatelessWidget {
  const _Training({Key? key, required this.training}) : super(key: key);

  final TrainingEntity training;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 25,
      ),
      height: 9.h,
      width: 92.5.w,
      blur: 20,
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.175),
          Colors.white.withOpacity(0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            training.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () async {
              await HapticFeedback.lightImpact();
              context.router.push(TrainingRoute(videoUrl: training.videoUrl));
            },
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  // ignore: unused_element
  const _Title(this.program, {Key? key, this.onTap}) : super(key: key);

  final ProgramEntity program;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          RoundedBackIcon(
            onTap: () {
              onTap;
            },
          ),
          const WBox(10),
          Hero(
            tag: program.id,
            child: Material(
              child: SizedBox(
                width: 180,
                child: Text(
                  program.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
