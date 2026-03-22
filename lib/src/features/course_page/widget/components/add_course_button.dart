import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/common/constants/app_strings.dart';
import 'package:insight/src/common/widgets/buttons/adaptive_button.dart';
import 'package:insight/src/features/course_page/bloc/course_enroll/course_enroll_bloc.dart';
import 'package:insight/src/features/course_page/bloc/course_enroll/course_enroll_state.dart';
import 'package:insight/src/features/learning/bloc/learning_bloc.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

/// Кнопка «Добавить курс» для страницы курса, когда пользователь не владелец
/// и ещё не зачислен на курс.
class AddCourseButton extends StatelessWidget {
  const AddCourseButton({super.key});

  static bool _hideButton(CourseEnrollState state) => state.maybeMap(
        processing: (s) => s.data == null,
        successful: (_) => true,
        orElse: () => false,
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CourseEnrollBloc, CourseEnrollState>(
          listenWhen: (prev, curr) =>
              curr.enrollSuccessGeneration > prev.enrollSuccessGeneration,
          listener: (context, state) {
            context.read<LearningBloc>().add(const LearningEvent.fetchLearning());
            context.read<LearningBloc>().add(const LearningEvent.fetchCurrent());
            final msg = state.snackbarMessage;
            if (msg != null) {
              InsightSnackBar.showSuccessful(context, text: msg);
              context.read<CourseEnrollBloc>().add(
                    const CourseEnrollEvent.acknowledgeSnackbar(),
                  );
            }
          },
        ),
        BlocListener<CourseEnrollBloc, CourseEnrollState>(
          listenWhen: (prev, curr) =>
              curr.snackbarIsError &&
              curr.snackbarMessage != null &&
              curr.snackbarMessage != prev.snackbarMessage,
          listener: (context, state) {
            InsightSnackBar.showError(
              context,
              text: state.snackbarMessage!,
            );
            context.read<CourseEnrollBloc>().add(
                  const CourseEnrollEvent.acknowledgeSnackbar(),
                );
          },
        ),
      ],
      child: BlocBuilder<CourseEnrollBloc, CourseEnrollState>(
        builder: (context, state) {
          if (_hideButton(state)) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AdaptiveButton(
              onPressed: state.isEnrolling
                  ? null
                  : () => context
                      .read<CourseEnrollBloc>()
                      .add(const CourseEnrollEvent.enroll()),
              child: Text(state.isEnrolling ? '...' : AppStrings.addCourse),
            ),
          );
        },
      ),
    );
  }
}
