import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/features/course/bloc/course_bloc.dart';
import 'package:insight/src/features/course/bloc/course_state.dart';
import 'package:insight/src/features/course/widget/components/course_list.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen(this.categoryTag, {super.key});

  final String categoryTag;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late final CourseBloc coursesBloc;

  @override
  void initState() {
    super.initState();
    coursesBloc = CourseBloc(
      repository: DIContainer.instance.coursesRepository,
    )..add(CourseEvent.fetch(widget.categoryTag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.categories),
      body: BlocProvider(
        create: (context) => coursesBloc,
        child: BlocConsumer<CourseBloc, CourseState>(
          listener: (context, state) => state.mapOrNull(
            error: (state) => InsightSnackBar.showError(
              context,
              text: state.message,
            ),
          ),
          builder: (context, state) {
            if (!state.hasData && state.hasError) {
              return InformationWidget.error(
                reloadFunc: () => coursesBloc.add(
                  CourseEvent.fetch(widget.categoryTag),
                ),
              );
            } else if (!state.hasData && !state.isProcessing) {
              return InformationWidget.empty(
                reloadFunc: () => coursesBloc.add(
                  CourseEvent.fetch(widget.categoryTag),
                ),
              );
            } else {
              return CourseList(
                courses: state.data,
                categoryTag: widget.categoryTag,
              );
            }
          },
        ),
      ),
    );
  }
}
