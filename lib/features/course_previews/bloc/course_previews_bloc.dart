import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/common/utilities/exception_to_message.dart';
import 'package:insight/features/course_previews/data/entities/course_preview_entity.dart';
import 'package:insight/features/course_previews/data/repositories/courses_preview_repository.dart';

part 'course_previews_bloc.freezed.dart';
part 'course_previews_event.dart';
part 'course_previews_state.dart';

class CoursePreviewsBloc
    extends Bloc<CoursePreviewsEvent, CoursePreviewsState> {
  final CoursesPreviewRepository coursesPreviewRepository;

  CoursePreviewsBloc(this.coursesPreviewRepository)
      : super(const CoursePreviewsState.idle()) {
    on<CoursePreviewsEvent>(
      (event, emit) => event.map(
        get: (event) => _get(emit, event),
      ),
    );
  }

  _get(Emitter<CoursePreviewsState> emit, GetCoursePreviewsEvent event) async {
    try {
      emit(const CoursePreviewsState.loading());
      final List<CoursePreviewEntity> coursePreviews =
          await coursesPreviewRepository.getCoursesPreview(event.categoryTag);
      coursePreviews.isNotEmpty
          ? emit(CoursePreviewsState.loaded(coursePreviews))
          : emit(const CoursePreviewsState.idle());
    } catch (e) {
      emit(CoursePreviewsState.error(exceptionToMessage(e)));
    }
  }
}
