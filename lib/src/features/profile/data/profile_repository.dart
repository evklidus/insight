import 'package:insight/src/features/profile/data/profile_network_data_provider.dart';
import 'package:insight/src/features/profile/model/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract interface class ProfileRepository {
  Future<User> getUser();
}

@immutable
final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(
    ProfileNetworkDataProvider profileNetworkDataProvider,
  ) : _profileNetworkDataProvider = profileNetworkDataProvider;

  final ProfileNetworkDataProvider _profileNetworkDataProvider;

  @override
  Future<User> getUser() => _profileNetworkDataProvider.getUser();
}
