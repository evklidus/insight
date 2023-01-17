import 'package:flutter/material.dart';
import 'package:insight/core/builders/entity_builder.dart';
import 'package:insight/features/courses_previews/presentation/screens/states/course_previews_screen_loaded.dart';
import 'package:insight/features/courses_previews/presentation/store/courses_preview_store.dart';
import 'package:insight/services/di/locator_service.dart';
import 'package:provider/provider.dart';

class CoursePreviewsScreen extends StatefulWidget {
  const CoursePreviewsScreen(this.categoryTag, {Key? key}) : super(key: key);

  final String categoryTag;

  @override
  State<CoursePreviewsScreen> createState() => _CoursePreviewsScreenState();
}

class _CoursePreviewsScreenState extends State<CoursePreviewsScreen> {
  final coursePreviewsStore = getIt.get<CoursesPreviewStore>();

  @override
  void initState() {
    coursePreviewsStore.loadCoursesPreview(widget.categoryTag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курсы'),
      ),
      body: Provider<CoursesPreviewStore>(
        create: (context) => coursePreviewsStore,
        builder: (context, _) {
          return const EntityBuilder<CoursesPreviewStore>(
            loadedWidget: CoursePreviewsScreenLoaded(),
          );
        },
      ),
    );
  }
}
