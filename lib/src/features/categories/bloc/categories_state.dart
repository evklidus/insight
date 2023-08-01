import 'package:equatable/equatable.dart';
import 'package:insight/src/features/categories/model/category.dart';
import 'package:meta/meta.dart';

/// {@template categories_state_placeholder}
/// Entity placeholder for CategoriesState
/// {@endtemplate}
typedef CategoriesEntity = List<Category>;

/// {@template categories_state}
/// CategoriesState.
/// {@endtemplate}
sealed class CategoriesState extends _$CategoriesStateBase {
  /// Idling state
  /// {@macro categories_state}
  const factory CategoriesState.idle({
    required CategoriesEntity? data,
    String message,
  }) = CategoriesState$Idle;

  /// Processing
  /// {@macro categories_state}
  const factory CategoriesState.processing({
    required CategoriesEntity? data,
    String message,
  }) = CategoriesState$Processing;

  /// Successful
  /// {@macro categories_state}
  const factory CategoriesState.successful({
    required CategoriesEntity? data,
    String message,
  }) = CategoriesState$Successful;

  /// An error has occurred
  /// {@macro categories_state}
  const factory CategoriesState.error({
    required CategoriesEntity? data,
    String message,
  }) = CategoriesState$Error;

  /// {@macro categories_state}
  const CategoriesState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class CategoriesState$Idle extends CategoriesState
    with _$CategoriesState {
  /// {@nodoc}
  const CategoriesState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class CategoriesState$Processing extends CategoriesState
    with _$CategoriesState {
  /// {@nodoc}
  const CategoriesState$Processing({
    required super.data,
    super.message = 'Processing',
  });
}

/// Successful
/// {@nodoc}
final class CategoriesState$Successful extends CategoriesState
    with _$CategoriesState {
  /// {@nodoc}
  const CategoriesState$Successful({
    required super.data,
    super.message = 'Successful',
  });
}

/// Error
/// {@nodoc}
final class CategoriesState$Error extends CategoriesState
    with _$CategoriesState {
  /// {@nodoc}
  const CategoriesState$Error({
    required super.data,
    super.message = 'An error has occurred.',
  });
}

/// {@nodoc}
base mixin _$CategoriesState on CategoriesState {}

/// Pattern matching for [CategoriesState].
typedef CategoriesStateMatch<R, S extends CategoriesState> = R Function(
  S state,
);

/// {@nodoc}
@immutable
abstract base class _$CategoriesStateBase with EquatableMixin {
  /// {@nodoc}
  const _$CategoriesStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final CategoriesEntity? data;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Has data?
  bool get hasData => data != null;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [CategoriesState].
  R map<R>({
    required CategoriesStateMatch<R, CategoriesState$Idle> idle,
    required CategoriesStateMatch<R, CategoriesState$Processing> processing,
    required CategoriesStateMatch<R, CategoriesState$Successful> successful,
    required CategoriesStateMatch<R, CategoriesState$Error> error,
  }) =>
      switch (this) {
        CategoriesState$Idle s => idle(s),
        CategoriesState$Processing s => processing(s),
        CategoriesState$Successful s => successful(s),
        CategoriesState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [CategoriesState].
  R maybeMap<R>({
    CategoriesStateMatch<R, CategoriesState$Idle>? idle,
    CategoriesStateMatch<R, CategoriesState$Processing>? processing,
    CategoriesStateMatch<R, CategoriesState$Successful>? successful,
    CategoriesStateMatch<R, CategoriesState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [CategoriesState].
  R? mapOrNull<R>({
    CategoriesStateMatch<R, CategoriesState$Idle>? idle,
    CategoriesStateMatch<R, CategoriesState$Processing>? processing,
    CategoriesStateMatch<R, CategoriesState$Successful>? successful,
    CategoriesStateMatch<R, CategoriesState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  List<Object?> get props => [data];
}
