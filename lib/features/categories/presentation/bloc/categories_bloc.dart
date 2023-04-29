import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/features/categories/domain/entities/category_entity.dart';
import 'package:insight/features/categories/domain/usecases/get_categories.dart';

part 'categories_bloc.freezed.dart';
part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategories getCategories;

  CategoriesBloc(this.getCategories) : super(const CategoriesState.idle()) {
    on<CategoriesEvent>(
      (event, emit) => event.map(
        get: (event) => _get(emit),
      ),
    );
  }

  _get(Emitter<CategoriesState> emit) async {
    emit(const CategoriesState.loading());
    final categories = await getCategories();
    categories.fold(
      (failure) => emit(const CategoriesState.error()),
      (categories) => categories.isNotEmpty
          ? emit(CategoriesState.loaded(categories))
          : emit(const CategoriesState.idle()),
    );
  }
}
