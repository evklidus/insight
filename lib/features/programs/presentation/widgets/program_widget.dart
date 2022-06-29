import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:m_sport/components/standart_loading.dart';
import 'package:m_sport/core/constants/color_constants.dart';
import 'package:m_sport/features/programs/domain/entities/program_entity.dart';
import 'package:m_sport/services/navigation/app_router.dart';

class ProgramWidget extends StatelessWidget {
  const ProgramWidget({Key? key, required this.program}) : super(key: key);

  final ProgramEntity program;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: GestureDetector(
        onTap: () {
          // String link = getIt<AppLinksService>().createDynamicLink( // TODO: Create dynamic link on firebase
          //   path: 'programs',
          //   queryMap: {},
          // );
          // log(link);
          context.pushRoute(ProgramPageRoute(program: program));
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              program.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return const StandartLoading();
              },
            ),
            Stack(
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
          ],
        ),
      ),
    );
  }
}
