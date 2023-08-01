import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/src/features/categories/bloc/categories_state.dart';
import 'package:insight/src/features/categories/model/category.dart';
import 'package:insight/src/features/categories/data/categories_repository.dart';

part 'categories_bloc.freezed.dart';
part 'categories_event.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({
    required CategoriesRepository repository,
    CategoriesState? initialState,
  })  : _repository = repository,
        super(initialState ?? const CategoriesState.idle(data: null)) {
    on<CategoriesEvent>(
      (event, emit) => event.map(
        fetch: (event) => _fetch(emit),
      ),
    );
  }

  final CategoriesRepository _repository;

  _fetch(Emitter<CategoriesState> emit) async {
    try {
      emit(CategoriesState.processing(data: state.data));
      final List<Category> categories = await _repository.getCategories();
      emit(CategoriesState.successful(data: categories));
    } on Object {
      emit(CategoriesState.error(data: state.data));
      rethrow;
    } finally {
      emit(CategoriesState.idle(data: state.data));
    }
  }
}
