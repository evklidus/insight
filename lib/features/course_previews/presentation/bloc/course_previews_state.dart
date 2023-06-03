part of 'course_previews_bloc.dart';

@freezed
class CoursePreviewsState with _$CoursePreviewsState {
  const factory CoursePreviewsState.idle() = CoursePreviewsIdleState;
  const factory CoursePreviewsState.loading() = CoursePreviewsLoadingState;
  const factory CoursePreviewsState.loaded(
    List<CoursePreviewEntity> coursePreviews,
  ) = CoursePreviewsLoadedState;
  const factory CoursePreviewsState.error(String errorMsg) =
      CoursePreviewsErrorState;
}
