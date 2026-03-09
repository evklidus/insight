import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/core/di_container/di_container.dart';
import 'package:insight/src/features/course/bloc/learning_bloc.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

/// Кнопка «Добавить курс» для страницы курса, когда пользователь не владелец
/// и ещё не зачислен на курс.
class AddCourseButton extends StatefulWidget {
  const AddCourseButton({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<AddCourseButton> createState() => _AddCourseButtonState();
}

class _AddCourseButtonState extends State<AddCourseButton> {
  bool _isEnrolled = false;
  bool _isLoading = true;
  bool _isEnrolling = false;

  @override
  void initState() {
    super.initState();
    _checkEnrollment();
  }

  /// insight_backend GetProgress всегда возвращает 200 с объектом.
  /// Зачислен = есть прогресс (status != not_started или watchedLessons не пусто).
  Future<void> _checkEnrollment() async {
    try {
      final progress = await DIContainer.instance.coursesRepository
          .getProgress(widget.courseId);
      if (mounted) {
        setState(() {
          _isEnrolled = progress != null &&
              (progress.status != 'not_started' ||
                  progress.watchedLessons.isNotEmpty);
          _isLoading = false;
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          _isEnrolled = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onEnroll() async {
    setState(() => _isEnrolling = true);
    try {
      await DIContainer.instance.coursesRepository.enroll(widget.courseId);
      if (mounted) {
        context.read<LearningBloc>().add(LearningEvent.fetchLearning);
        context.read<LearningBloc>().add(LearningEvent.fetchCurrent);
        InsightSnackBar.showSuccessful(
          context,
          text: AppStrings.successful,
        );
        setState(() {
          _isEnrolled = true;
          _isEnrolling = false;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        if (e.response?.statusCode == 409) {
          setState(() {
            _isEnrolled = true;
            _isEnrolling = false;
          });
        } else {
          final errMsg = e.response?.data is Map
              ? (e.response!.data as Map)['error']?.toString()
              : null;
          InsightSnackBar.showError(
            context,
            text: errMsg ?? e.toString(),
          );
          setState(() => _isEnrolling = false);
        }
      }
    } on Object catch (e) {
      if (mounted) {
        InsightSnackBar.showError(context, text: e.toString());
        setState(() => _isEnrolling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isEnrolled) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AdaptiveButton(
        onPressed: _isEnrolling ? null : _onEnroll,
        child: Text(_isEnrolling ? '...' : AppStrings.addCourse),
      ),
    );
  }
}
