import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/course_page/bloc/course_page_state.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/course_page/model/course_edit.dart';
import 'package:insight/src/features/course_page/model/lesson.dart';

part 'course_page_event.dart';

class CoursePageBloc extends Bloc<CoursePageEvent, CoursePageState> {
  CoursePageBloc({
    required CoursePageRepository repository,
    CoursePageState? initialState,
  })  : _repository = repository,
        super(initialState ?? const CoursePageState.idle(data: null)) {
    on<CoursePageEvent>(
      (event, emit) => switch (event) {
        _CoursePageEvent$Fetch() => _fetch(emit, event),
        _CoursePageEvent$Edit() => _edit(emit, event),
        _CoursePageEvent$AddLesson() => _addLesson(emit, event),
        _CoursePageEvent$RemoveLesson() => _removeLesson(emit, event),
        _CoursePageEvent$Delete() => _delete(emit, event),
      },
    );
  }

  final CoursePageRepository _repository;

  Future<void> _fetch(
    Emitter<CoursePageState> emit,
    _CoursePageEvent$Fetch event,
  ) async {
    try {
      emit(CoursePageState.processing(data: state.data));
      final coursePage = await _repository.getCoursePage(event.id);
      emit(CoursePageState.successful(data: coursePage));
    } on Object {
      emit(CoursePageState.error(
        data: state.data,
        message: 'Ошибка получения курса',
      ));
      rethrow;
    } finally {
      emit(CoursePageState.idle(data: state.data));
    }
  }

  Future<void> _edit(
    Emitter<CoursePageState> emit,
    _CoursePageEvent$Edit event,
  ) async {
    try {
      emit(
        CoursePageState.processing(
          data: state.data?.copyWith(
            name: event.course.name,
            description: event.course.description,
          ),
        ),
      );
      await _repository.editCourse(event.course);
      final coursePage = await _repository.getCoursePage(state.data!.id);
      emit(CoursePageState.successful(data: coursePage));
    } on Object {
      emit(CoursePageState.error(
        data: state.data,
        message: 'Ошибка редактирования курса',
      ));
      rethrow;
    } finally {
      emit(CoursePageState.idle(data: state.data));
    }
  }

  Future<void> _addLesson(
    Emitter<CoursePageState> emit,
    _CoursePageEvent$AddLesson event,
  ) async {
    try {
      emit(CoursePageState.processing(data: state.data));
      await _repository.addLesson(
        courseId: state.data!.id,
        lessonName: event.name,
        videoPath: event.videoPath,
      );
      event.onAdd();
      final coursePage = await _repository.getCoursePage(state.data!.id);
      emit(CoursePageState.successful(data: coursePage));
    } on Object {
      emit(CoursePageState.error(
        data: state.data,
        message: 'Ошибка добавления урока',
      ));
      rethrow;
    } finally {
      emit(CoursePageState.idle(data: state.data));
    }
  }

  Future<void> _removeLesson(
    Emitter<CoursePageState> emit,
    _CoursePageEvent$RemoveLesson event,
  ) async {
    try {
      emit(CoursePageState.processing(data: state.data));
      await _repository.removeLesson(
        courseId: state.data!.id,
        lesson: event.lesson,
      );
      event.onRemove();
      final coursePage = await _repository.getCoursePage(state.data!.id);
      emit(CoursePageState.successful(data: coursePage));
    } on Object {
      emit(CoursePageState.error(
        data: state.data,
        message: 'Ошибка удаления урока',
      ));
      rethrow;
    } finally {
      emit(CoursePageState.idle(data: state.data));
    }
  }

  Future<void> _delete(
    Emitter<CoursePageState> emit,
    _CoursePageEvent$Delete event,
  ) async {
    try {
      emit(CoursePageState.processing(data: state.data));
      await _repository.deleteCourse(
        courseId: state.data!.id,
        imageUrl: state.data!.imageUrl,
      );
      event.onDelete();
      emit(CoursePageState.successful(data: state.data));
    } on Object {
      emit(CoursePageState.error(
        data: state.data,
        message: 'Ошибка удаления курса',
      ));
      rethrow;
    } finally {
      emit(CoursePageState.idle(data: state.data));
    }
  }
}
