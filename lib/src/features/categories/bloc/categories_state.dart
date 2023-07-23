part of 'categories_bloc.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState.idle() = CategoriesIdleState;
  const factory CategoriesState.loading() = CategoriesLoadingState;
  const factory CategoriesState.loaded(List<Category> categories) =
      CategoriesLoadedState;
  const factory CategoriesState.error(String errorMsg) = CategoriesErrorState;
}
