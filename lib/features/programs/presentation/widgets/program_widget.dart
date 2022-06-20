import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:m_sport/core/constants/color_constants.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/services/di/locator_service.dart';
import 'package:m_sport/services/links/applinks_service.dart';
import 'package:m_sport/services/navigation/app_router.dart';

class ProgramWidget extends StatelessWidget {
  const ProgramWidget({Key? key, required this.program}) : super(key: key);

  final ProgramEntity program;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: InkWell(
        onTap: () {
          String link = getIt<AppLinksService>().createDynamicLink(
            path: 'programs',
            queryMap: {},
          );
          log(link);
          context.pushRoute(TrainingsListRoute(program: program));
        },
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(program.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                height: 40,
                decoration: const BoxDecoration(
                  gradient: ColorConstants.shadowGradient,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: program.id,
                      child: Material(
                        child: SizedBox(
                          width: 140.0,
                          child: Text(
                            program.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
