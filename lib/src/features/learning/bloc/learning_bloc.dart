import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/course/data/course_repository.dart';
import 'package:insight/src/features/learning/bloc/learning_state.dart';
import 'package:insight/src/features/learning/data/learning_repository.dart';

part 'learning_event.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  LearningBloc({
    required LearningRepository learningRepository,
    required CourseRepository courseRepository,
  })  : _learningRepository = learningRepository,
        _courseRepository = courseRepository,
        super(const LearningState.idle()) {
    on<LearningEvent>(
      (event, emit) => switch (event) {
        _LearningEvent$FetchCurrent() => _fetchCurrent(emit),
        _LearningEvent$FetchLearning() => _fetchLearning(emit),
        _LearningEvent$Clear() => emit(const LearningState.idle()),
        _LearningEvent$CompleteLesson e => _completeLesson(emit, e),
        _LearningEvent$Enroll e => _enroll(emit, e),
      },
    );
  }

  final LearningRepository _learningRepository;
  final CourseRepository _courseRepository;

  Future<void> _fetchCurrent(Emitter<LearningState> emit) async {
    emit(
      LearningState.processing(
        current: state.current,
        learning: state.learning,
      ),
    );
    try {
      final current = await _learningRepository.getCurrent();
      emit(
        LearningState.successful(
          current: current,
          learning: state.learning,
        ),
      );
    } on Object catch (e) {
      emit(
        LearningState.error(
          current: state.current,
          learning: state.learning,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _fetchLearning(Emitter<LearningState> emit) async {
    emit(
      LearningState.processing(
        current: state.current,
        learning: state.learning,
      ),
    );
    try {
      final learning = await _learningRepository.getMyLearning();
      emit(
        LearningState.successful(
          current: state.current,
          learning: learning,
        ),
      );
    } on Object catch (e) {
      emit(
        LearningState.error(
          current: state.current,
          learning: state.learning,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _completeLesson(
    Emitter<LearningState> emit,
    _LearningEvent$CompleteLesson event,
  ) async {
    try {
      await _courseRepository.completeLesson(event.courseId, event.lessonId);
      add(const LearningEvent.fetchCurrent());
      add(const LearningEvent.fetchLearning());
    } on Object {
      rethrow;
    }
  }

  Future<void> _enroll(
    Emitter<LearningState> emit,
    _LearningEvent$Enroll event,
  ) async {
    emit(
      LearningState.processing(
        current: state.current,
        learning: state.learning,
      ),
    );
    try {
      await _courseRepository.enroll(event.courseId);
      add(const LearningEvent.fetchLearning());
      emit(
        LearningState.successful(
          current: state.current,
          learning: state.learning,
        ),
      );
    } on Object catch (e) {
      emit(
        LearningState.error(
          current: state.current,
          learning: state.learning,
          message: e.toString(),
        ),
      );
      rethrow;
    }
  }
}
