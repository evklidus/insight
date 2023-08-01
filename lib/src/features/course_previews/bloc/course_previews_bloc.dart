import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/src/features/course_previews/bloc/course_previews_state.dart';
import 'package:insight/src/features/course_previews/model/course_preview.dart';
import 'package:insight/src/features/course_previews/data/courses_preview_repository.dart';

part 'course_previews_bloc.freezed.dart';
part 'course_previews_event.dart';

class CoursePreviewsBloc
    extends Bloc<CoursePreviewsEvent, CoursePreviewsState> {
  CoursePreviewsBloc({
    required CoursesPreviewRepository repository,
    CoursePreviewsState? initialState,
  })  : _repository = repository,
        super(initialState ?? const CoursePreviewsState.idle(data: null)) {
    on<CoursePreviewsEvent>(
      (event, emit) => event.map<Future<void>>(
        fetch: (event) => _fetch(emit, event),
      ),
    );
  }

  final CoursesPreviewRepository _repository;

  _fetch(
    Emitter<CoursePreviewsState> emit,
    GetCoursePreviewsEvent event,
  ) async {
    try {
      emit(CoursePreviewsState.processing(data: state.data));
      final List<CoursePreview> coursePreviews =
          await _repository.getCoursesPreview(event.categoryTag);
      emit(CoursePreviewsState.successful(data: coursePreviews));
    } on Object {
      emit(CoursePreviewsState.error(data: state.data));
      rethrow;
    } finally {
      emit(CoursePreviewsState.idle(data: state.data));
    }
  }
}
