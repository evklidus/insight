part of 'nickname_bloc.dart';

sealed class NicknameEvent {
  const NicknameEvent();

  const factory NicknameEvent.save({
    required String? newNickname,
    required String? oldNickname,
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) = _NicknameEvent$Save;
}

final class _NicknameEvent$Save extends NicknameEvent {
  const _NicknameEvent$Save({
    required this.newNickname,
    required this.oldNickname,
    required this.onSuccess,
    required this.onError,
  });

  final String? newNickname;
  final String? oldNickname;
  final VoidCallback onSuccess;
  final VoidCallback onError;
}
