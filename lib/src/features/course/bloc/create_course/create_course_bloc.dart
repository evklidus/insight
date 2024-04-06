import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insight/src/features/course/data/course_repository.dart';

import 'create_course_event.dart';
import 'create_course_state.dart';

/// Business Logic Component CreateCourseBLoC
class CreateCourseBLoC extends Bloc<CreateCourseEvent, CreateCourseState> {
  CreateCourseBLoC({
    required final CourseRepository repository,
    final CreateCourseState? initialState,
  })  : _repository = repository,
        super(
          initialState ??
              const CreateCourseState.idle(
                data: CreateCourseEntity(),
                message: 'Initial idle state',
              ),
        ) {
    on<CreateCourseEvent>(
      (event, emit) => switch (event) {
        CreateCourseEvent$Create _ => _create(event, emit),
      },
    );
  }

  final CourseRepository _repository;

  /// Create event handler
  Future<void> _create(
    CreateCourseEvent$Create event,
    Emitter<CreateCourseState> emit,
  ) async {
    try {
      emit(CreateCourseState.processing(data: state.data));
      await _repository.createCourse(
        name: event.name,
        description: event.description,
        imagePath: event.imagePath,
        categoryTag: event.categoryTag,
      );
      emit(
        CreateCourseState.successful(
          data: state.data,
          message: 'Курс успешно создан!',
        ),
      );
    } on Object catch (_) {
      emit(
        CreateCourseState.error(
          data: state.data,
          message: 'Произошла ошибка при создании курса, попробуйте позже',
        ),
      );
      rethrow;
    } finally {
      emit(CreateCourseState.idle(data: state.data));
    }
  }
}
