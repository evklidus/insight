part of 'categories_bloc.dart';

sealed class CategoriesEvent {
  const CategoriesEvent();

  const factory CategoriesEvent.fetch() = _CategoriesEvent$Fetch;
}

final class _CategoriesEvent$Fetch extends CategoriesEvent {
  const _CategoriesEvent$Fetch();
}
