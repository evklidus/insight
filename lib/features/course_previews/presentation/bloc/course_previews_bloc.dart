import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/features/course_previews/domain/entities/course_preview_entity.dart';
import 'package:insight/features/course_previews/domain/usecases/get_course_previews.dart';

part 'course_previews_bloc.freezed.dart';
part 'course_previews_event.dart';
part 'course_previews_state.dart';

class CoursePreviewsBloc
    extends Bloc<CoursePreviewsEvent, CoursePreviewsState> {
  final GetCoursePreviews getCoursePreviews;

  CoursePreviewsBloc(this.getCoursePreviews)
      : super(const CoursePreviewsState.idle()) {
    on<CoursePreviewsEvent>(
      (event, emit) => event.map(
        get: (event) => _get(emit, event),
      ),
    );
  }

  _get(Emitter<CoursePreviewsState> emit, GetCoursePreviewsEvent event) async {
    emit(const CoursePreviewsState.loading());
    final coursePreviews = await getCoursePreviews(
      CoursePreviewsParams(
        categoryTag: event.categoryTag,
      ),
    );
    coursePreviews.fold(
      (failure) => emit(const CoursePreviewsState.error()),
      (coursePreviews) => coursePreviews.isNotEmpty
          ? emit(CoursePreviewsState.loaded(coursePreviews))
          : emit(const CoursePreviewsState.idle()),
    );
  }
}
