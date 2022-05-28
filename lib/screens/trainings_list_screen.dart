import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:m_sport/components/hbox.dart';
import 'package:m_sport/components/rounded_back_icon.dart';
import 'package:m_sport/components/wbox.dart';
import 'package:m_sport/models/program.dart';
import 'package:m_sport/models/training.dart';
import 'package:m_sport/services/navigation/app_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TrainingsListScreen extends StatelessWidget {
  const TrainingsListScreen({Key? key, required this.program}) : super(key: key);

  final Program program;

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
                _Title(program.name),
                const HBox(25),
                Column(
                  children: program.trainings
                      .map(
                        (training) => _Training(
                          training: training,
                        ),
                      )
                      .toList(),
                ),
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

  final Training training;

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
  const _Title(this.title, {Key? key, this.onTap}) : super(key: key);

  final String title;
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
            tag: 'Main title',
            child: Material(
              child: SizedBox(
                width: 180,
                child: Text(
                  title,
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
