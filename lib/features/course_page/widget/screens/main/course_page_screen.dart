import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/core/di/locator_service.dart';
import 'package:insight/common/widgets/app_bars/insight_app_bar_with_back_button.dart';
import 'package:insight/common/widgets/information_widget.dart';
import 'package:insight/common/widgets/loadings/standart_loading.dart';
import 'package:insight/features/course_page/domain/bloc/course_page_bloc.dart';
import 'package:insight/features/course_page/widget/screens/states/course_page_screen_loaded.dart';

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
  final coursePageBloc = getIt.get<CoursePageBloc>();

  @override
  void initState() {
    super.initState();
    coursePageBloc.add(CoursePageEvent.get(widget.coursePageId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InsightAppBarWithBackButton(widget.coursePageTitle),
      body: BlocBuilder<CoursePageBloc, CoursePageState>(
        bloc: coursePageBloc,
        builder: (context, state) => state.when(
          idle: () => InformationWidget.idle(
            reloadFunc: () => coursePageBloc.add(
              CoursePageEvent.get(widget.coursePageId),
            ),
          ),
          loading: () => const StandartLoading(),
          loaded: (coursePageEntity) => CoursePageScreenLoaded(
            coursePageEntity: coursePageEntity,
          ),
          error: (errorMsg) => InformationWidget.error(
            description: errorMsg,
            reloadFunc: () => coursePageBloc.add(
              CoursePageEvent.get(widget.coursePageId),
            ),
          ),
        ),
      ),
    );
  }
}
