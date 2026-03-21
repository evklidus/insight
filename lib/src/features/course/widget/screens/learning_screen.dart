import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/widgets/adaptive_scaffold.dart';
import 'package:insight/src/common/widgets/app_bars/custom_sliver_app_bar.dart';
import 'package:insight/src/common/widgets/custom_android_refresh_indicator.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/information_widget.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';
import 'package:insight/src/common/widgets/separated_column.dart';
import 'package:insight/src/common/widgets/shimmer.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/features/auth/widget/auth_scope.dart';
import 'package:insight/src/features/course/bloc/learning_bloc.dart';
import 'package:insight/src/features/course/bloc/learning_state.dart';
import 'package:insight/src/features/course/model/learning_course.dart';
import 'package:insight/src/features/profile/model/user_current_lesson.dart';
import 'package:insight/src/features/course/widget/components/course_widget.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

/// Экран таба «Учёба»: текущий урок + курсы, на которые записан пользователь.
class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late final LearningBloc _learningBloc;
  @override
  void initState() {
    super.initState();
    _learningBloc = context.read<LearningBloc>();
    if (AuthScope.of(context, listen: false).isAuthenticated) {
      _learningBloc.add(LearningEvent.fetchCurrent);
      _learningBloc.add(LearningEvent.fetchLearning);
    }
  }

  Future<void> _onRefresh() async {
    _learningBloc.add(LearningEvent.fetchCurrent);
    _learningBloc.add(LearningEvent.fetchLearning);
    await _learningBloc.stream.first;
  }

  @override
  Widget build(BuildContext context) {
    return CustomAndroidRefreshIndicator(
      onRefresh: _onRefresh,
      child: AdaptiveScaffold(
        body: CustomScrollView(
          slivers: [
            const CustomSliverAppBar(
              title: AppStrings.learning,
            ),
            CupertinoSliverRefreshControl(onRefresh: _onRefresh),
            if (!AuthScope.of(context).isAuthenticated)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: InformationWidget.empty(
                    title: AppStrings.needAuthToCreateCourse,
                    description: AppStrings.signIn,
                  ),
                ),
              )
            else
              BlocConsumer<LearningBloc, LearningState>(
                listenWhen: (prev, curr) => curr.hasError && !prev.hasError,
                listener: (context, state) => InsightSnackBar.showError(
                  context,
                  text: state.message ?? AppStrings.somethingWrong,
                ),
                builder: (context, state) => SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _CurrentLessonBlock(current: state.current),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    _LearningCoursesBlock(
                      learning: state.learning,
                      isProcessing: state.isProcessing,
                      hasError: state.hasError,
                      onRefresh: _onRefresh,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CurrentLessonBlock extends StatelessWidget {
  const _CurrentLessonBlock({this.current});

  final UserCurrentLesson? current;

  @override
  Widget build(BuildContext context) {
    final lesson = current;
    if (lesson == null) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: ShapeDecoration(
        color: context.colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      margin: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 9),
            child: Text(
              AppStrings.currentLesson,
              style: context.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(4),
            child: InsightListTile(
              backgroundColor: context.colorScheme.surfaceContainer,
              padding: const EdgeInsets.all(8),
              onTap: () => context.pushNamed(
                RouteKeys.coursePage.name,
                pathParameters: {'coursePageId': lesson.courseId},
              ),
              leadingSize: 60,
              leading: CustomImageWidget(
                resolveStorageUrl(lesson.imageUrl),
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                lesson.lessonName,
                maxLines: 3,
                style: context.textTheme.titleLarge,
              ),
              subtitle: Text(
                'Курс: ${lesson.courseName}',
                maxLines: 2,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: IconButton(
                onPressed: () => context.pushNamed(
                  RouteKeys.video.name,
                  pathParameters: {
                    'coursePageTitle': lesson.lessonName,
                  },
                  queryParameters: <String, String>{
                    'videoUrl': resolveStorageUrl(lesson.lessonVideoUrl),
                    'courseId': lesson.courseId,
                    if (lesson.lessonId.isNotEmpty) 'lessonId': lesson.lessonId,
                  },
                ),
                icon: Icon(
                  isNeedCupertino
                      ? CupertinoIcons.play_fill
                      : Icons.play_arrow_rounded,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningCoursesBlock extends StatelessWidget {
  const _LearningCoursesBlock({
    required this.learning,
    required this.isProcessing,
    required this.hasError,
    required this.onRefresh,
  });

  final List<LearningCourse> learning;
  final bool isProcessing;
  final bool hasError;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return WidgetSwitcher.sliver(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      state: (
        hasData: !isProcessing && !hasError,
        isProcessing: isProcessing,
        hasError: hasError,
      ),
      skeletonBuilder: (context) => SliverToBoxAdapter(
        child: SeparatedColumn(
          itemCount: 3,
          itemBuilder: (context, index) => const Shimmer(
            size: Size.fromHeight(92),
            cornerRadius: 24,
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
        ),
      ),
      refresh: onRefresh,
      childBuilder: (context) => learning.isEmpty
          ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: InformationWidget.empty(
                  title: AppStrings.noCourses,
                  description: AppStrings.noCoursesDescription,
                  reloadFunc: null,
                ),
              ),
            )
          : SliverAnimatedList(
              initialItemCount: learning.length,
              itemBuilder: (context, index, _) {
                final learningCourse = learning[index];
                final userId = context.read<ProfileBloc>().state.data?.id;
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
                          'coursePageId': learningCourse.course.id.toString(),
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
    );
  }
}
