import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/snackbar/error_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/app_bars/insight_app_bar_with_back_button.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/features/course_previews/bloc/course_previews_bloc.dart';
import 'package:insight/src/features/course_previews/bloc/course_previews_state.dart';
import 'package:insight/src/features/course_previews/widget/components/course_previews_list.dart';
import 'package:insight/src/features/course_previews/widget/components/course_previews_skeleton.dart';

class CoursePreviewsScreen extends StatefulWidget {
  const CoursePreviewsScreen(this.categoryTag, {Key? key}) : super(key: key);

  final String categoryTag;

  @override
  State<CoursePreviewsScreen> createState() => _CoursePreviewsScreenState();
}

class _CoursePreviewsScreenState extends State<CoursePreviewsScreen> {
  late final CoursePreviewsBloc coursePreviewsBloc;

  @override
  void initState() {
    super.initState();
    coursePreviewsBloc =
        CoursePreviewsBloc(repository: DIContainer().coursesPreviewRepository)
          ..add(CoursePreviewsEvent.fetch(widget.categoryTag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InsightAppBarWithBackButton(AppStrings.courses),
      body: BlocProvider(
        create: (context) => coursePreviewsBloc,
        child: BlocConsumer<CoursePreviewsBloc, CoursePreviewsState>(
          listener: (context, state) => state.mapOrNull(
            error: (state) => ErrorSnackBar.show(
              context,
              error: state.message,
            ),
          ),
          builder: (context, state) {
            if (!state.hasData && state.isProcessing) {
              return const CoursePreviewsSkeleton();
            } else if (!state.hasData && state.hasError) {
              return InformationWidget.error(
                reloadFunc: () => coursePreviewsBloc.add(
                  CoursePreviewsEvent.fetch(widget.categoryTag),
                ),
              );
            } else if (!state.hasData) {
              return InformationWidget.empty(
                reloadFunc: () => coursePreviewsBloc.add(
                  CoursePreviewsEvent.fetch(widget.categoryTag),
                ),
              );
            } else {
              return CoursePreviewsList(
                coursePreviews: state.data!,
              );
            }
          },
        ),
      ),
    );
  }
}
