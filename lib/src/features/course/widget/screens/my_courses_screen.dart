import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_sliver_app_bar.dart';
import 'package:insight/src/common/widgets/custom_android_refresh_indicator.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/widgets/separated_column.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/features/course/bloc/course_bloc.dart';
import 'package:insight/src/features/course/bloc/course_state.dart';
import 'package:insight/src/features/course/widget/components/course_widget.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

/// Экран «Мои курсы» — курсы, которые пользователь создал.
class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  late final CourseBloc _courseBloc;

  @override
  void initState() {
    super.initState();
    _courseBloc = CourseBloc(
      repository: DIContainer.instance.coursesRepository,
    )..add(const CourseEvent.fetchUserCourses());
  }

  Future<void> _onRefresh() async {
    _courseBloc.add(const CourseEvent.fetchUserCourses());
    await _courseBloc.stream.first;
  }

  @override
  void dispose() {
    _courseBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: CustomAndroidRefreshIndicator(
        onRefresh: _onRefresh,
        child: AdaptiveScaffold(
          body: CustomScrollView(
            slivers: [
              const CustomSliverAppBar(
                title: AppStrings.myCourses,
                previousPageTitle: AppStrings.settings,
              ),
              CupertinoSliverRefreshControl(onRefresh: _onRefresh),
              BlocConsumer<CourseBloc, CourseState>(
                listenWhen: (prev, curr) => curr.hasError && !prev.hasError,
                listener: (context, state) => InsightSnackBar.showError(
                  context,
                  text: state.message,
                ),
                builder: (context, state) => WidgetSwitcher.sliver(
                  state: (
                    hasData: !state.isProcessing && !state.hasError,
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
                  childBuilder: (context) {
                    final courses = state.data ?? [];
                    if (courses.isEmpty) {
                      return SliverToBoxAdapter(
                        child: InformationWidget.empty(
                          title: AppStrings.noCreatedCourses,
                          description: AppStrings.noCreatedCoursesDescription,
                          reloadFunc: null,
                        ),
                      );
                    }
                    return SliverAnimatedList(
                      initialItemCount: courses.length,
                      itemBuilder: (context, index, _) {
                        final course = courses[index];
                        final userId =
                            context.read<ProfileBloc>().state.data?.id;
                        return Column(
                          children: [
                            if (index != 0) const SizedBox(height: 20),
                            CourseWidget.withCategory(
                              course: course,
                              categoryTag: course.tag,
                              userId: userId,
                              statusBadge: null,
                              onTap: () => context.pushNamed(
                                RouteKeys.coursePage.name,
                                pathParameters: {
                                  'coursePageId': course.id.toString(),
                                },
                                extra: () => _courseBloc
                                    .add(const CourseEvent.fetchUserCourses()),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
