import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:insight/components/standart_loading.dart';
import 'package:insight/core/constants/color_constants.dart';
import 'package:insight/features/courses_preview/domain/entities/course_preview_entity.dart';
import 'package:insight/services/navigation/app_router.dart';

class CoursePreviewWidget extends StatelessWidget {
  const CoursePreviewWidget({Key? key, required this.coursePreview})
      : super(key: key);

  final CoursePreviewEntity coursePreview;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: GestureDetector(
        onTap: () {
          // String link = getIt<AppLinksService>().createDynamicLink( // TODO: Create dynamic link on firebase
          //   path: 'coursePreviews',
          //   queryMap: {},
          // );
          // log(link);
          context
              .pushRoute(CoursePreviewPageRoute(coursePreview: coursePreview));
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              coursePreview.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
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
                        tag: coursePreview.name,
                        child: Material(
                          child: SizedBox(
                            width: 140.0,
                            child: Text(
                              coursePreview.name,
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
