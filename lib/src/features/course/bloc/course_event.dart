part of 'course_bloc.dart';

@freezed
class CourseEvent with _$CourseEvent {
  const factory CourseEvent.fetch(String categoryTag) = GetCourseEvent;
}
