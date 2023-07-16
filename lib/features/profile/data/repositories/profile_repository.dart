import 'package:insight/features/profile/data/data_provider/profile_data_provider.dart';
import 'package:insight/features/profile/model/user.dart';

abstract class ProfileRepository {
  Future<User> getUser();
}

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(ProfileDataProvider profileDataProvider)
      : _profileDataProvider = profileDataProvider;

  final ProfileDataProvider _profileDataProvider;

  @override
  Future<User> getUser() => _profileDataProvider.getUser();
}
