import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/features/course/data/course_repository.dart';
import 'package:insight/src/features/course_page/bloc/course_enroll/course_enroll_data.dart';
import 'package:insight/src/features/course_page/bloc/course_enroll/course_enroll_state.dart';
import 'package:insight/src/features/learning/data/learning_repository.dart';

part 'course_enroll_event.dart';

class CourseEnrollBloc extends Bloc<CourseEnrollEvent, CourseEnrollState> {
  CourseEnrollBloc({
    required String courseId,
    required LearningRepository learningRepository,
    required CourseRepository courseRepository,
  })  : _courseId = courseId,
        _learningRepository = learningRepository,
        _courseRepository = courseRepository,
        super(
          const CourseEnrollState.processing(
            data: null,
            message: '',
          ),
        ) {
    on<CourseEnrollEvent>(
      (event, emit) => switch (event) {
        _CourseEnrollEvent$Check() => _check(emit),
        _CourseEnrollEvent$Enroll() => _enroll(emit),
        _CourseEnrollEvent$AcknowledgeSnackbar() => _acknowledgeSnackbar(emit),
      },
    );
  }

  final String _courseId;
  final LearningRepository _learningRepository;
  final CourseRepository _courseRepository;

  Future<void> _check(Emitter<CourseEnrollState> emit) async {
    try {
      final learning = await _learningRepository.getMyLearning();
      final enrolled = learning.any((lc) => lc.course.id == _courseId);
      if (enrolled) {
        emit(
          const CourseEnrollState.successful(
            data: CourseEnrollData(
              isUserEnrolled: true,
              enrollSuccessGeneration: 0,
            ),
            message: 'Successful',
          ),
        );
      } else {
        emit(
          const CourseEnrollState.idle(
            data: CourseEnrollData(
              isUserEnrolled: false,
              enrollSuccessGeneration: 0,
            ),
            message: 'Idling',
          ),
        );
      }
    } on Object {
      emit(
        const CourseEnrollState.idle(
          data: CourseEnrollData(
            isUserEnrolled: false,
            enrollSuccessGeneration: 0,
          ),
          message: 'Idling',
        ),
      );
    }
  }

  Future<void> _enroll(Emitter<CourseEnrollState> emit) async {
    final before = state;
    if (before is! CourseEnrollState$Idle) {
      return;
    }
    final d = before.data;
    if (d == null || d.isUserEnrolled) {
      return;
    }
    emit(
      CourseEnrollState.processing(
        data: CourseEnrollData(
          enrollSuccessGeneration: d.enrollSuccessGeneration,
          isEnrolling: true,
          isUserEnrolled: false,
        ),
        message: 'Processing',
      ),
    );
    try {
      await _courseRepository.enroll(_courseId);
      emit(
        CourseEnrollState.successful(
          data: CourseEnrollData(
            isUserEnrolled: true,
            enrollSuccessGeneration: d.enrollSuccessGeneration + 1,
            snackbarMessage: AppStrings.successful,
          ),
          message: 'Successful',
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        emit(
          CourseEnrollState.successful(
            data: CourseEnrollData(
              isUserEnrolled: true,
              enrollSuccessGeneration: d.enrollSuccessGeneration + 1,
            ),
            message: 'Successful',
          ),
        );
      } else {
        final errMsg = e.response?.data is Map
            ? (e.response!.data as Map)['error']?.toString()
            : null;
        emit(
          CourseEnrollState.idle(
            data: CourseEnrollData(
              enrollSuccessGeneration: d.enrollSuccessGeneration,
              isUserEnrolled: false,
              snackbarMessage: errMsg ?? e.toString(),
              snackbarIsError: true,
            ),
            message: 'Idling',
          ),
        );
      }
    } on Object catch (e) {
      emit(
        CourseEnrollState.idle(
          data: CourseEnrollData(
            enrollSuccessGeneration: d.enrollSuccessGeneration,
            isUserEnrolled: false,
            snackbarMessage: e.toString(),
            snackbarIsError: true,
          ),
          message: 'Idling',
        ),
      );
    }
  }

  void _acknowledgeSnackbar(Emitter<CourseEnrollState> emit) {
    final s = state;
    if (s is CourseEnrollState$Idle) {
      final data = s.data;
      if (data != null && data.snackbarMessage != null) {
        emit(
          CourseEnrollState.idle(
            data: CourseEnrollData(
              enrollSuccessGeneration: data.enrollSuccessGeneration,
              isUserEnrolled: data.isUserEnrolled,
            ),
            message: 'Idling',
          ),
        );
      }
      return;
    }
    if (s is CourseEnrollState$Successful) {
      final data = s.data;
      if (data != null && data.snackbarMessage != null) {
        emit(
          CourseEnrollState.successful(
            data: CourseEnrollData(
              isUserEnrolled: data.isUserEnrolled,
              enrollSuccessGeneration: data.enrollSuccessGeneration,
            ),
            message: 'Successful',
          ),
        );
      }
    }
  }
}
