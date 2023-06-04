part of 'course_previews_bloc.dart';

@freezed
class CoursePreviewsEvent with _$CoursePreviewsEvent {
  const factory CoursePreviewsEvent.get(String categoryTag) =
      GetCoursePreviewsEvent;
}
