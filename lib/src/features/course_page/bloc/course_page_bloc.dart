import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/course_page/bloc/course_page_state.dart';
import 'package:insight/src/features/course_page/data/course_page_repository.dart';
import 'package:insight/src/features/course_page/model/course_page.dart';

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
      },
    );
  }

  final CoursePageRepository _repository;

  _fetch(Emitter<CoursePageState> emit, _CoursePageEvent$Fetch event) async {
    try {
      emit(CoursePageState.processing(data: state.data));
      final CoursePage coursePage = await _repository.getCoursePage(event.id);
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
}
