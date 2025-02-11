import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/repositories/parent_repository.dart';
import 'parent_auth_event.dart';
import 'parent_auth_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ParentAuthBloc extends Bloc<ParentAuthEvent, ParentAuthState> {
  final ParentRepository parentRepository;
  final FlutterSecureStorage secureStorage;

  ParentAuthBloc({required this.parentRepository, required this.secureStorage})
      : super(ParentAuthInitial()) {
    on<ParentRegisterRequested>(_onRegisterRequested);
    on<ParentEmailVerificationRequested>(_parentEmailVerification);
    on<ParentResendEmailVerificationRequested>(_parentResendEmailVerification);
    on<ParentCompleteRegistrationRequested>(_parentCompleteRegistration);
    on<ParentLoginRequested>(_parentLogin);
  }

  ///======================================================
  /// Handles the ParentRegisterRequested event.
  /// =====================================================
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
      emit(ParentRegistrationSuccess(message: message, email: event.email));
    } catch (e) {
      emit(ParentRegistrationFailure(error: e.toString()));
    }
  }

  ///======================================================
  /// handle ParentEmailVerificationRequested event
  /// =====================================================
  Future<void> _parentEmailVerification(ParentEmailVerificationRequested event,
      Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());
    try {
      final message = await parentRepository.parentEmailVerification(
        code: event.code,
      );
      emit(ParentEmailVerificationSuccess(message: message));
    } catch (e) {
      emit(ParentEmailVerificationFailure(error: e.toString()));
    }
  }

  ///======================================================
  /// handle ParentResendEmailVerificationRequested event
  /// =====================================================
  Future<void> _parentResendEmailVerification(
      ParentResendEmailVerificationRequested event,
      Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());

    try {
      final message = await parentRepository.parentResendEmailVerification(
          email: event.email);
      emit(ParentResendVerificationSuccess(message: message));
    } catch (e) {
      emit(ParentResendVerificationFailure(message: e.toString()));
    }
  }

  ///======================================================
  /// handle ParentCompleteRegistrationRequested event
  /// =====================================================
  Future<void> _parentCompleteRegistration(
      ParentCompleteRegistrationRequested event,
      Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());

    try {
      final completeRegistrationResponse =
          await parentRepository.parentCompleteRegistration(
              birthDate: event.birthDate,
              phoneNumber: event.phoneNumber,
              addressPostal: event.addressPostal);

      final message = completeRegistrationResponse.message;
      final parent = completeRegistrationResponse.parent;

      emit(ParentCompleteRegistrationSuccess(parent: parent, message: message));
    } catch (e) {
      emit(ParentCompleteRegistrationFailure(error: e.toString()));
    }
  }

  ///======================================================
  /// handle ParentLoginRequested event
  /// =====================================================
  Future<void> _parentLogin(ParentLoginRequested event, Emitter<ParentAuthState> emit) async {

    emit(ParentAuthLoading());
    try {
      final parentLoginResponse = await parentRepository.parentLogin(
          email: event.email, password: event.password);
      final parent = parentLoginResponse.parent;
      final message = parentLoginResponse.message;
      final accessToken = parentLoginResponse.accessToken;
      final refreshToken = parentLoginResponse.refreshToken;

      await secureStorage.write(key: 'accessToken', value: accessToken);
      await secureStorage.write(key: 'refreshToken', value: refreshToken);

      emit(ParentLoginSuccess(
        parent: parent,
        message: message,
        accessToken: accessToken,
        refreshToken: refreshToken,
      ));
    } catch (e) {
      emit(ParentLoginFailure(error: e.toString()));
    }
  }
}
