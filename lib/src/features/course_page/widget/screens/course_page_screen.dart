import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/snackbar/error_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/app_bars/insight_app_bar_with_back_button.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/src/features/course_page/bloc/course_page_state.dart';
import 'package:insight/src/features/course_page/widget/components/course_page_skeleton.dart';
import 'package:insight/src/features/course_page/widget/components/course_page_info.dart';

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
  late final CoursePageBloc coursePageBloc;

  @override
  void initState() {
    super.initState();
    coursePageBloc =
        CoursePageBloc(repository: DIContainer.instance.coursePageRepository)
          ..add(CoursePageEvent.fetch(widget.coursePageId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InsightAppBarWithBackButton(widget.coursePageTitle),
      body: BlocProvider(
        create: (context) => coursePageBloc,
        child: BlocConsumer<CoursePageBloc, CoursePageState>(
          listener: (context, state) => state.mapOrNull(
            error: (errorState) =>
                ErrorSnackBar.show(context, error: errorState.message),
          ),
          builder: (context, state) {
            if (!state.hasData && state.isProcessing) {
              return const CoursePageSkeleton();
            } else if (!state.hasData && state.hasError) {
              return InformationWidget.error(
                reloadFunc: () => coursePageBloc.add(
                  CoursePageEvent.fetch(widget.coursePageId),
                ),
              );
            } else if (!state.hasData) {
              return InformationWidget.empty(
                reloadFunc: () => coursePageBloc.add(
                  CoursePageEvent.fetch(widget.coursePageId),
                ),
              );
            } else {
              return CoursePageInfo(coursePage: state.data!);
            }
          },
        ),
      ),
    );
  }
}
