import 'package:flutter/material.dart';
import 'package:insight/components/boxes/h_box.dart';
import 'package:insight/core/builders/entity_builder.dart';
import 'package:insight/core/constants/color_constants.dart';
import 'package:insight/features/course_page/presentation/screens/states/course_page_screen_loaded.dart';
import 'package:insight/features/course_page/presentation/store/course_page_store.dart';
import 'package:insight/features/course_page/presentation/widgets/course_page_screen_title.dart';
import 'package:insight/services/di/locator_service.dart';
import 'package:insight/utilities/load_states.dart';
import 'package:provider/provider.dart';

class CoursePageScreen extends StatefulWidget {
  const CoursePageScreen({
    Key? key,
    required this.coursePageId,
    required this.coursePageTitle,
  }) : super(key: key);

  final int coursePageId;
  final String coursePageTitle;

  @override
  State<CoursePageScreen> createState() => _CoursePageScreenState();
}

class _CoursePageScreenState extends State<CoursePageScreen> {
  final coursePageStore = getIt.get<CoursePageStore>();

  @override
  void initState() {
    coursePageStore.loadCoursePage(widget.coursePageId);
    coursePageStore.loadState = LoadStates.loading;
    coursePageStore.reloadFunc =
        () => coursePageStore.loadCoursePage(widget.coursePageId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: ColorConstants.coursePageGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                CoursePageScreenTitle(widget.coursePageTitle),
                const HBox(25),
                Provider<CoursePageStore>(
                  create: (context) => coursePageStore,
                  builder: (context, _) {
                    return const Expanded(
                      child: EntityBuilder<CoursePageStore>(
                        loadedWidget: CoursePageScreenLoaded(),
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
