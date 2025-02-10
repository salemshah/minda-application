import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/repositories/parent_repository.dart';
import 'parent_auth_event.dart';
import 'parent_auth_state.dart';

class ParentAuthBloc extends Bloc<ParentAuthEvent, ParentAuthState> {
  final ParentRepository parentRepository;

  ParentAuthBloc({required this.parentRepository})
      : super(ParentAuthInitial()) {
    // Handle parent registration events.
    on<ParentRegisterRequested>(_onRegisterRequested);
    // Handle parent email verification event
    on<ParentEmailVerificationRequested>(_parentEmailVerification);
  }

  /// Handles the ParentRegisterRequested event.
  Future<void> _onRegisterRequested(
      ParentRegisterRequested event, Emitter<ParentAuthState> emit) async {
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

  Future<void> _parentEmailVerification(ParentEmailVerificationRequested event,
      Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());
    try {
      final message = await parentRepository.parentEmailVerification(
        code: event.code,
      );
      emit(ParentAuthSuccess(message: message));
    } catch (e) {
      emit(ParentAuthFailure(error: e.toString()));
    }
  }
}
