import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/src/common/utilities/exception_to_message.dart';
import 'package:insight/src/features/categories/model/category.dart';
import 'package:insight/src/features/categories/data/categories_repository.dart';

part 'categories_bloc.freezed.dart';
part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository categoriesRepository;

  CategoriesBloc(this.categoriesRepository)
      : super(const CategoriesState.idle()) {
    on<CategoriesEvent>(
      (event, emit) => event.map(
        get: (event) => _get(emit),
      ),
    );
  }

  _get(Emitter<CategoriesState> emit) async {
    try {
      emit(const CategoriesState.loading());
      final List<Category> categories =
          await categoriesRepository.getCategories();
      categories.isNotEmpty
          ? emit(CategoriesState.loaded(categories))
          : emit(const CategoriesState.idle());
    } catch (e) {
      emit(CategoriesState.error(exceptionToMessage(e)));
    }
  }
}
