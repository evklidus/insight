import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_sliver_app_bar.dart';
import 'package:insight/src/common/widgets/custom_android_refresh_indicator.dart';
import 'package:insight/src/common/widgets/separated_column.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/features/course/widget/components/course_widget.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/course/bloc/course_bloc.dart';
import 'package:insight/src/features/course/bloc/course_state.dart';

class UserCoursesScreen extends StatefulWidget {
  const UserCoursesScreen({super.key});

  @override
  State<UserCoursesScreen> createState() => _UserCoursesScreenState();
}

class _UserCoursesScreenState extends State<UserCoursesScreen> {
  late final CourseBloc coursesBloc;

  @override
  void initState() {
    super.initState();
    coursesBloc = CourseBloc(
      repository: DIContainer.instance.coursesRepository,
    )..add(const CourseEvent.fetchUserCourses());
  }

  Future<void> _onRefresh() async {
    final block = coursesBloc.stream.first;
    coursesBloc.add(const CourseEvent.fetchUserCourses());
    await block;
  }

  @override
  Widget build(BuildContext context) {
    return CustomAndroidRefreshIndicator(
      onRefresh: _onRefresh,
      child: AdaptiveScaffold(
        body: CustomScrollView(
          slivers: [
            const CustomSliverAppBar(
              title: AppStrings.myCourses,
              previousPageTitle: AppStrings.settings,
            ),
            CupertinoSliverRefreshControl(onRefresh: _onRefresh),
            BlocProvider(
              create: (context) => coursesBloc,
              child: BlocConsumer<CourseBloc, CourseState>(
                listener: (context, state) => state.mapOrNull(
                  error: (state) => InsightSnackBar.showError(
                    context,
                    text: state.message,
                  ),
                ),
                builder: (context, state) => WidgetSwitcher.sliver(
                  state: (
                    hasData: state.hasData,
                    isProcessing: state.isProcessing,
                    hasError: state.hasError,
                  ),
                  skeletonBuilder: (context) => SliverToBoxAdapter(
                    child: SeparatedColumn(
                      itemCount: 3,
                      itemBuilder: (context, index) => const Shimmer(
                        size: Size.fromHeight(92),
                        cornerRadius: 24,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                    ),
                  ),
                  refresh: _onRefresh,
                  childBuilder: (context) => SliverAnimatedList(
                      initialItemCount: state.data!.length,
                      itemBuilder: (context, index, _) {
                        final course = state.data![index];
                        return Column(
                          children: [
                            if (index != 0) const SizedBox(height: 20),
                            CourseWidget.withCategory(
                              course: course,
                              categoryTag: course.tag,
                              onTap: () => context.pushNamed(
                                RouteKeys.coursePage.name,
                                pathParameters: {
                                  'coursePageId': course.id.toString(),
                                },
                                extra: () => coursesBloc.add(
                                  const CourseEvent.fetchUserCourses(),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
