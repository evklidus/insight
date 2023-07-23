import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/src/common/utilities/exception_to_message.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';

part 'course_page_bloc.freezed.dart';
part 'course_page_event.dart';
part 'course_page_state.dart';

class CoursePageBloc extends Bloc<CoursePageEvent, CoursePageState> {
  final CoursePageRepository coursePageRepository;

  CoursePageBloc(this.coursePageRepository)
      : super(const CoursePageState.idle()) {
    on<CoursePageEvent>(
      (event, emit) => event.map(
        get: (event) => _get(emit, event),
      ),
    );
  }

  _get(Emitter<CoursePageState> emit, GetCoursePageEvent event) async {
    try {
      emit(const CoursePageState.loading());
      final CoursePage coursePage =
          await coursePageRepository.getCoursePage(event.id);
      emit(CoursePageState.loaded(coursePage));
    } catch (e) {
      emit(CoursePageState.error(exceptionToMessage(e)));
    }
  }
}
