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
                tags: null,
                message: 'Initial idle state',
              ),
        ) {
    on<CreateCourseEvent>(
      (event, emit) => switch (event) {
        CreateCourseEvent$FetchTags _ => _fetchTags(event, emit),
        CreateCourseEvent$Create _ => _create(event, emit),
      },
    );
  }

  final CourseRepository _repository;

  /// Fetch tags event handler
  Future<void> _fetchTags(
    CreateCourseEvent$FetchTags event,
    Emitter<CreateCourseState> emit,
  ) async {
    try {
      emit(CreateCourseState.processing(tags: state.tags));
      final tags = await _repository.getCategoryTags();
      emit(
        CreateCourseState.successful(tags: tags),
      );
    } on Object catch (_) {
      emit(
        CreateCourseState.error(
          tags: state.tags,
          message: 'Произошла ошибка при создании курса, попробуйте позже',
        ),
      );
      rethrow;
    } finally {
      emit(CreateCourseState.idle(tags: state.tags));
    }
  }

  /// Create event handler
  Future<void> _create(
    CreateCourseEvent$Create event,
    Emitter<CreateCourseState> emit,
  ) async {
    try {
      emit(CreateCourseState.processing(tags: state.tags));
      await _repository.createCourse(
        name: event.name,
        description: event.description,
        imagePath: event.imagePath,
        categoryTag: event.categoryTag,
      );
      event.onCreateCallback?.call();
      emit(
        CreateCourseState.successful(tags: state.tags),
      );
    } on Object catch (_) {
      emit(
        CreateCourseState.error(
          tags: state.tags,
          message: 'Произошла ошибка при создании курса, попробуйте позже',
        ),
      );
      rethrow;
    } finally {
      emit(CreateCourseState.idle(tags: state.tags));
    }
  }
}
