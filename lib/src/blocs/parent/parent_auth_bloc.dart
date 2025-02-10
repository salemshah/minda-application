import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/repositories/parent_repository.dart';
import 'parent_auth_event.dart';
import 'parent_auth_state.dart';

class ParentAuthBloc extends Bloc<ParentAuthEvent, ParentAuthState> {
  final ParentRepository parentRepository;
  ParentAuthBloc({required this.parentRepository})
      : super(ParentAuthInitial()) {
    on<ParentRegisterRequested>(_onRegisterRequested);
  }

  /// Handles the ParentRegisterRequested event.
  ///
  /// This asynchronous function is called when a ParentRegisterRequested event is received.
  /// It performs the registration process and emits new states based on the outcome.
  Future<void> _onRegisterRequested(
      ParentRegisterRequested event, // The event carrying registration details.
      Emitter<ParentAuthState> emit) async { // Function used to emit new states.
    emit(ParentAuthLoading());

    try {
      final message = await parentRepository.registerParent(
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        password: event.password,
      );

      emit(ParentAuthSuccess(message: message));

    } catch (e) {
      emit(ParentAuthFailure(error: e.toString()));
    }
  }
}
