import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_sliver_app_bar.dart';
import 'package:insight/src/common/widgets/custom_android_refresh_indicator.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/widgets/separated_column.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/features/course/bloc/learning_bloc.dart';
import 'package:insight/src/features/course/bloc/learning_state.dart';
import 'package:insight/src/features/course/widget/components/course_widget.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

class UserCoursesScreen extends StatefulWidget {
  const UserCoursesScreen({super.key});

  @override
  State<UserCoursesScreen> createState() => _UserCoursesScreenState();
}

class _UserCoursesScreenState extends State<UserCoursesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LearningBloc>().add(LearningEvent.fetchLearning);
  }

  Future<void> _onRefresh() async {
    context.read<LearningBloc>().add(LearningEvent.fetchLearning);
    await context.read<LearningBloc>().stream.first;
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
            BlocConsumer<LearningBloc, LearningState>(
              listenWhen: (prev, curr) => curr.hasError && !prev.hasError,
              listener: (context, state) => InsightSnackBar.showError(
                context,
                text: state.message ?? AppStrings.somethingWrong,
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
                childBuilder: (context) => state.learning.isEmpty
                    ? SliverToBoxAdapter(
                        child: InformationWidget.empty(
                          title: AppStrings.noCourses,
                          description: AppStrings.noCoursesDescription,
                          reloadFunc: null,
                        ),
                      )
                    : SliverAnimatedList(
                        initialItemCount: state.learning.length,
                        itemBuilder: (context, index, _) {
                          final learningCourse = state.learning[index];
                          final userId =
                              context.read<ProfileBloc>().state.data?.id;
                          return Column(
                            children: [
                              if (index != 0) const SizedBox(height: 20),
                              CourseWidget.withCategory(
                                course: learningCourse.course,
                                categoryTag: learningCourse.course.tag,
                                userId: userId,
                                statusBadge: learningCourse.statusLabel,
                                onTap: () => context.pushNamed(
                                  RouteKeys.coursePage.name,
                                  pathParameters: {
                                    'coursePageId':
                                        learningCourse.course.id.toString(),
                                  },
                                  extra: () => context
                                      .read<LearningBloc>()
                                      .add(LearningEvent.fetchLearning),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
