import 'package:insight/src/features/profile/data/profile_network_data_provider.dart';
import 'package:insight/src/features/profile/model/user.dart';
import 'package:insight/src/features/profile/model/user_edit.dart';
import 'package:meta/meta.dart';

@immutable
abstract interface class ProfileRepository {
  Future<User?> getUser();
  Future<void> editUser(User$Edit user);
  Future<void> editNickname({
    required String? newNickname,
    required String? oldNickname,
  });
}

@immutable
final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(
    ProfileNetworkDataProvider profileNetworkDataProvider,
  ) : _profileNetworkDataProvider = profileNetworkDataProvider;

  final ProfileNetworkDataProvider _profileNetworkDataProvider;

  @override
  Future<User?> getUser() => _profileNetworkDataProvider.getUser();

  @override
  Future<void> editUser(User$Edit user) =>
      _profileNetworkDataProvider.editUser(user);

  @override
  Future<void> editNickname({
    required String? newNickname,
    required String? oldNickname,
  }) =>
      _profileNetworkDataProvider.editNickname(
        newNickname: newNickname,
        oldNickname: oldNickname,
      );
}
