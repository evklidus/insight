import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/invitations/bloc/invitations_state.dart';
import 'package:insight/src/features/invitations/data/invitations_repository.dart';

part 'invitations_event.dart';

class InvitationsBloc extends Bloc<InvitationsEvent, InvitationsState> {
  InvitationsBloc({required InvitationsRepository repository})
      : _repository = repository,
        super(const InvitationsState()) {
    on<InvitationsEvent>(
      (event, emit) => switch (event) {
        _InvitationsEvent$Fetch() => _fetch(emit),
      },
    );
  }

  final InvitationsRepository _repository;

  Future<void> _fetch(Emitter<InvitationsState> emit) async {
    try {
      emit(state.copyWith(isProcessing: true, hasError: false));
      final invitations = await _repository.getMyInvitations();
      emit(state.copyWith(
        invitations: invitations,
        isProcessing: false,
      ));
    } on Object catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasError: true,
        message: e.toString(),
      ));
    }
  }
}
