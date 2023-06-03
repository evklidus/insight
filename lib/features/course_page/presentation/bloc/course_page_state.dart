part of 'course_page_bloc.dart';

@freezed
class CoursePageState with _$CoursePageState {
  const factory CoursePageState.idle() = CoursePageIdleState;
  const factory CoursePageState.loading() = CoursePageLoadingState;
  const factory CoursePageState.loaded(CoursePageEntity coursePage) =
      CoursePageLoadedState;
  const factory CoursePageState.error(String errorMsg) = CoursePageErrorState;
}
