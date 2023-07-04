part of 'course_page_bloc.dart';

@freezed
class CoursePageEvent with _$CoursePageEvent {
  const factory CoursePageEvent.get(int id) = GetCoursePageEvent;
}
