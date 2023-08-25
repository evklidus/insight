import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/course/bloc/course_state.dart';
import 'package:insight/src/features/course/model/course.dart';
import 'package:insight/src/features/course/data/course_repository.dart';

part 'course_event.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc({
    required CourseRepository repository,
    CourseState? initialState,
  })  : _repository = repository,
        super(initialState ?? const CourseState.idle(data: null)) {
    on<CourseEvent>(
      (event, emit) => switch (event) {
        _CourseEvent$Fetch() => _fetch(emit, event),
      },
    );
  }

  final CourseRepository _repository;

  _fetch(
    Emitter<CourseState> emit,
    _CourseEvent$Fetch event,
  ) async {
    try {
      emit(CourseState.processing(data: state.data));
      final List<Course> courses =
          await _repository.getCourse(event.categoryTag);
      emit(CourseState.successful(data: courses));
    } on Object {
      emit(CourseState.error(data: state.data));
      rethrow;
    } finally {
      emit(CourseState.idle(data: state.data));
    }
  }
}
