import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/separated_column.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/features/course/widget/components/course_widget.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/app_bars/custom_app_bar.dart';
import 'package:insight/src/features/course/bloc/course_bloc.dart';
import 'package:insight/src/features/course/bloc/course_state.dart';

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
    return AdaptiveScaffold(
      appBar: const CustomAppBar(
        title: AppStrings.courses,
        previousPageTitle: AppStrings.categories,
      ),
      body: ListView(
        children: [
          BlocProvider(
            create: (context) => coursesBloc,
            child: BlocConsumer<CourseBloc, CourseState>(
              listener: (context, state) => state.mapOrNull(
                error: (state) => InsightSnackBar.showError(
                  context,
                  text: state.message,
                ),
              ),
              builder: (context, state) => WidgetSwitcher(
                state: (
                  hasData: state.hasData,
                  isProcessing: state.isProcessing,
                  hasError: state.hasError,
                ),
                skeletonBuilder: (context) => SeparatedColumn(
                  itemCount: 3,
                  itemBuilder: (context, index) => const Shimmer(
                    size: Size.fromHeight(92),
                    cornerRadius: 24,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                ),
                childBuilder: (context) => AnimatedList(
                  initialItemCount: state.data!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index, _) => Column(
                    children: [
                      if (index != 0) const SizedBox(height: 20),
                      CourseWidget(
                        course: state.data![index],
                        categoryTag: widget.categoryTag,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
