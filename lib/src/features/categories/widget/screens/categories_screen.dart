import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insight/src/common/constants/base_constants.dart';
import 'package:insight/src/common/constants/route_keys.dart';
import 'package:insight/src/common/utils/extensions/context_extension.dart';
import 'package:insight/src/common/utils/extensions/go_relative_named.dart';
import 'package:insight/src/common/utils/extensions/object_x.dart';
import 'package:insight/src/common/widgets/app_bars/custom_sliver_app_bar.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/common/widgets/custom_android_refresh_indicator.dart';
import 'package:insight/src/common/widgets/custom_image_widget.dart';
import 'package:insight/src/common/widgets/insight_list_tile.dart';
import 'package:insight/src/common/widgets/widget_switcher.dart';
import 'package:insight/src/features/auth/widget/auth_scope.dart';
import 'package:insight/src/features/profile/bloc/profile_bloc.dart';
import 'package:insight/src/features/profile/bloc/profile_state.dart';
import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/features/categories/bloc/categories_bloc.dart';
import 'package:insight/src/features/categories/bloc/categories_state.dart';
import 'package:insight/src/features/categories/widget/components/categories_grid.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late final CategoriesBloc categoriesBloc;

  @override
  void initState() {
    super.initState();
    categoriesBloc =
        CategoriesBloc(repository: DIContainer.instance.categoriesRepository)
          ..add(const CategoriesEvent.fetch());
  }

  Future<void> _onRefresh() async {
    final block = categoriesBloc.stream.first;
    categoriesBloc.add(const CategoriesEvent.fetch());
    await block;
  }

  @override
  Widget build(BuildContext context) {
    final authScope = AuthScope.of(context);

    return CustomAndroidRefreshIndicator(
      onRefresh: _onRefresh,
      child: BlocProvider(
        create: (context) => categoriesBloc,
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              title: AppStrings.categories,
              action: AdaptiveButton(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  isNeedCupertino
                      ? CupertinoIcons.add_circled_solid
                      : Icons.add_circle,
                  color: context.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                onPressed: () => authScope.isAuthenticated
                    ? context.goRelativeNamed(RouteKeys.create.name)
                    : InsightSnackBar.showError(
                        context,
                        text: AppStrings.needAuthToCreateCourse,
                      ),
              ),
            ),
            CupertinoSliverRefreshControl(onRefresh: _onRefresh),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final currentLesson = state.data?.currentLessons?.first;
                return currentLesson.isNotNull
                    ? SliverToBoxAdapter(
                        child: Container(
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
                                padding:
                                    const EdgeInsets.only(left: 12, top: 9),
                                child: Text(
                                  AppStrings.currentLesson,
                                  style: context.textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: InsightListTile(
                                  backgroundColor:
                                      context.colorScheme.surfaceContainer,
                                  padding: const EdgeInsets.all(8),
                                  onTap: () => context.pushNamed(
                                    RouteKeys.coursePage.name,
                                    pathParameters: {
                                      'coursePageId': currentLesson.courseId,
                                    },
                                  ),
                                  leadingSize: 60,
                                  leading: CustomImageWidget(
                                    currentLesson!.imageUrl,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    currentLesson.lessonName,
                                    maxLines: 3,
                                    style: context.textTheme.titleLarge,
                                  ),
                                  subtitle: Text(
                                    'Курс: ${currentLesson.courseName}',
                                    maxLines: 2,
                                    style:
                                        context.textTheme.labelSmall?.copyWith(
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () => context.pushNamed(
                                      RouteKeys.video.name,
                                      pathParameters: {
                                        'coursePageTitle':
                                            currentLesson.lessonName,
                                      },
                                      queryParameters: {
                                        'videoUrl':
                                            currentLesson.lessonVideoUrl,
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
                        ),
                      )
                    : const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            BlocConsumer<CategoriesBloc, CategoriesState>(
              listener: (context, state) => state.mapOrNull(
                error: (errorState) => InsightSnackBar.showError(context,
                    text: errorState.message),
              ),
              builder: (context, state) => WidgetSwitcher.sliver(
                state: (
                  hasData: state.hasData,
                  isProcessing: state.isProcessing,
                  hasError: state.hasError,
                ),
                skeletonBuilder: (context) => const CategoriesGridSkeleton(),
                childBuilder: (context) =>
                    CategoriesGrid(categories: state.data!),
              ),
            )
          ],
        ),
      ),
    );
  }
}
