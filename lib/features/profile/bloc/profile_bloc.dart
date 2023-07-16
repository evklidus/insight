import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insight/common/utilities/exception_to_message.dart';
import 'package:insight/features/profile/data/repositories/profile_repository.dart';
import 'package:insight/features/profile/model/user.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(ProfileRepository profileRepository)
      : _profileRepository = profileRepository,
        super(const ProfileState.idle()) {
    on<ProfileEvent>(
      (event, emit) => event.map(
        get: (event) => _get(emit),
      ),
    );
  }

  Future<void> _get(Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    try {
      final user = await _profileRepository.getUser();
      emit(ProfileState.loaded(user));
    } catch (e) {
      emit(ProfileState.error(exceptionToMessage(e)));
    }
  }
}
