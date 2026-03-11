import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/course/bloc/learning_state.dart';
import 'package:insight/src/features/course/data/course_repository.dart';

part 'learning_event.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  LearningBloc({required CourseRepository repository})
      : _repository = repository,
        super(const LearningState()) {
    on<LearningEvent>(
      (event, emit) => switch (event) {
        _LearningEvent$FetchCurrent() => _fetchCurrent(emit),
        _LearningEvent$FetchLearning() => _fetchLearning(emit),
        _LearningEvent$Clear() => emit(const LearningState()),
        _LearningEvent$CompleteLesson e => _completeLesson(emit, e),
        _LearningEvent$Enroll e => _enroll(emit, e),
      },
    );
  }

  final CourseRepository _repository;

  Future<void> _fetchCurrent(Emitter<LearningState> emit) async {
    try {
      emit(state.copyWith(isProcessing: true, hasError: false));
      final current = await _repository.getCurrent();
      emit(state.copyWith(
        current: current,
        isProcessing: false,
      ));
    } on Object catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasError: true,
        message: e.toString(),
      ));
    }
  }

  Future<void> _fetchLearning(Emitter<LearningState> emit) async {
    try {
      emit(state.copyWith(isProcessing: true, hasError: false));
      final learning = await _repository.getMyLearning();
      emit(state.copyWith(
        learning: learning,
        isProcessing: false,
      ));
    } on Object catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasError: true,
        message: e.toString(),
      ));
    }
  }

  Future<void> _completeLesson(
    Emitter<LearningState> emit,
    _LearningEvent$CompleteLesson event,
  ) async {
    try {
      await _repository.completeLesson(event.courseId, event.lessonId);
      add(LearningEvent.fetchCurrent);
      add(LearningEvent.fetchLearning);
    } on Object {
      rethrow;
    }
  }

  Future<void> _enroll(
    Emitter<LearningState> emit,
    _LearningEvent$Enroll event,
  ) async {
    try {
      emit(state.copyWith(isProcessing: true, hasError: false));
      await _repository.enroll(event.courseId);
      add(LearningEvent.fetchLearning);
      emit(state.copyWith(isProcessing: false));
    } on Object catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasError: true,
        message: e.toString(),
      ));
      rethrow;
    }
  }
}
