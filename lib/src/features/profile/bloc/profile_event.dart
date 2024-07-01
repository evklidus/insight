part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();

  const factory ProfileEvent.fetch() = _ProfileEvent$Fetch;

  const factory ProfileEvent.edit(User$Edit user) = _ProfileEvent$Edit;

  const factory ProfileEvent.clear() = _ProfileEvent$Clear;
}

final class _ProfileEvent$Fetch extends ProfileEvent {
  const _ProfileEvent$Fetch();
}

final class _ProfileEvent$Edit extends ProfileEvent {
  const _ProfileEvent$Edit(this.user);

  final User$Edit user;
}

final class _ProfileEvent$Clear extends ProfileEvent {
  const _ProfileEvent$Clear();
}
