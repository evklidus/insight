part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();

  const factory ProfileEvent.fetch() = _ProfileEvent$Fetch;
}

final class _ProfileEvent$Fetch extends ProfileEvent {
  const _ProfileEvent$Fetch();
}
