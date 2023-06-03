import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/common/utilities/exception_to_message.dart';
import 'package:insight/features/course_page/domain/entities/course_page_entity.dart';
import 'package:insight/features/course_page/domain/repositories/course_page_repository.dart';

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
      final CoursePageEntity coursePage =
          await coursePageRepository.getCoursePage(event.id);
      emit(CoursePageState.loaded(coursePage));
    } catch (e) {
      emit(CoursePageState.error(exceptionToMessage(e)));
    }
  }
}
