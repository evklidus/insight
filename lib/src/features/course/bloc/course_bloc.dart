import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/course/bloc/course_state.dart';
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
        _CourseEvent$FetchUserCourses() => _fetchUserCourses(emit, event),
      },
    );
  }

  final CourseRepository _repository;

  Future<void> _fetch(
    Emitter<CourseState> emit,
    _CourseEvent$Fetch event,
  ) async {
    try {
      emit(CourseState.processing(data: state.data));
      final courses = await _repository.getCourse(event.categoryTag);
      emit(CourseState.successful(data: courses));
    } on Object {
      emit(CourseState.error(data: state.data));
      rethrow;
    } finally {
      emit(CourseState.idle(data: state.data));
    }
  }

  Future<void> _fetchUserCourses(
    Emitter<CourseState> emit,
    _CourseEvent$FetchUserCourses event,
  ) async {
    try {
      emit(CourseState.processing(data: state.data));
      final courses = await _repository.getUserCourse();
      emit(CourseState.successful(data: courses));
    } on Object {
      emit(CourseState.error(data: state.data));
      rethrow;
    } finally {
      emit(CourseState.idle(data: state.data));
    }
  }
}
