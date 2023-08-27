import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/custom_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/features/course_page/bloc/course_page_bloc.dart';
import 'package:insight/src/features/course_page/bloc/course_page_state.dart';
import 'package:insight/src/features/course_page/widget/components/course_page_skeleton.dart';
import 'package:insight/src/features/course_page/widget/components/course_page_info.dart';

class CoursePageScreen extends StatefulWidget {
  const CoursePageScreen({
    Key? key,
    required this.coursePageId,
  }) : super(key: key);

  final String coursePageId;

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
      appBar: const CustomAppBar(AppStrings.courses),
      body: BlocProvider(
        create: (context) => coursePageBloc,
        child: BlocConsumer<CoursePageBloc, CoursePageState>(
          listener: (context, state) => state.mapOrNull(
            error: (errorState) =>
                CustomSnackBar.showError(context, message: errorState.message),
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
