import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/core/sl/locator_service.dart';
import 'package:insight/src/common/widgets/app_bars/insight_app_bar_with_back_button.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/widgets/loadings/standart_loading.dart';
import 'package:insight/src/features/course_previews/bloc/course_previews_bloc.dart';
import 'package:insight/src/features/course_previews/widget/screens/states/course_previews_screen_loaded.dart';

class CoursePreviewsScreen extends StatefulWidget {
  const CoursePreviewsScreen(this.categoryTag, {Key? key}) : super(key: key);

  final String categoryTag;

  @override
  State<CoursePreviewsScreen> createState() => _CoursePreviewsScreenState();
}

class _CoursePreviewsScreenState extends State<CoursePreviewsScreen> {
  final coursePreviewsBloc = getIt.get<CoursePreviewsBloc>();

  @override
  void initState() {
    super.initState();
    coursePreviewsBloc.add(CoursePreviewsEvent.get(widget.categoryTag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InsightAppBarWithBackButton(AppStrings.courses),
      body: BlocBuilder<CoursePreviewsBloc, CoursePreviewsState>(
        bloc: coursePreviewsBloc,
        builder: (context, state) => state.when(
          idle: () => InformationWidget.idle(
            reloadFunc: () => coursePreviewsBloc.add(
              CoursePreviewsEvent.get(widget.categoryTag),
            ),
          ),
          loading: () => const StandartLoading(),
          loaded: (coursePreviews) => CoursePreviewsScreenLoaded(
            coursePreviews: coursePreviews,
          ),
          error: (errorMsg) => InformationWidget.error(
            description: errorMsg,
            reloadFunc: () => coursePreviewsBloc.add(
              CoursePreviewsEvent.get(widget.categoryTag),
            ),
          ),
        ),
      ),
    );
  }
}
