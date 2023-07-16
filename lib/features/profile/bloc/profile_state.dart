part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.idle() = _ProfileIdleState;
  const factory ProfileState.loading() = _ProfileLoadingState;
  const factory ProfileState.loaded(User user) = _ProfileLoadedState;
  const factory ProfileState.error(String errorMsg) = _ProfileErrorState;
}
