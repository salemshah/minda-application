import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:minda_application/src/repositories/parent_repository.dart';
import 'parent_auth_event.dart';
import 'parent_auth_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ParentAuthBloc extends Bloc<ParentAuthEvent, ParentAuthState> {
  final ParentRepository parentRepository;
  final FlutterSecureStorage secureStorage;

  ParentAuthBloc({required this.parentRepository, required this.secureStorage})
      : super(ParentAuthInitial()) {
    on<CheckParentTokenExpiration>(_onCheckParentTokenExpiration);
    on<ParentRegisterRequested>(_onRegisterRequested);
    on<ParentEmailVerificationRequested>(_parentEmailVerification);
    on<ParentResendEmailVerificationRequested>(_parentResendEmailVerification);
    on<ParentCompleteRegistrationRequested>(_parentCompleteRegistration);
    on<ParentLoginRequested>(_parentLogin);
    on<ParentGetProfileRequested>(_parentGetProfile);
    on<ParentLogoutRequested>(_parentLogout);
    on<ParentUpdateProfileRequested>(_parentUpdateProfile);
    on<ParentUpdatePasswordRequested>(_onParentUpdatePassword);
    on<ParentChildRegistrationRequested>(_onParentChildRegistration);
    on<ParentChildGetRequested>(_onParentChildGet);
  }

  ///======================================================
  /// Handles the CheckParentTokenExpiration event.
  /// =====================================================
  Future<void> _onCheckParentTokenExpiration(
      CheckParentTokenExpiration event, Emitter<ParentAuthState> emit) async {
    final token = await secureStorage.read(key: 'accessToken');
    if (token != null && !JwtDecoder.isExpired(token)) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
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
      String errorMessage = parseErrorMessage(e);
      emit(ParentRegistrationFailure(error: errorMessage));
    }
  }

  ///======================================================
  /// Handles the ParentRegisterRequested event.
  /// =====================================================
  Future<void> _onParentUpdatePassword(ParentUpdatePasswordRequested event,
      Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());
    try {
      final message = await parentRepository.updateParentPassword(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      emit(ParentUpdatePasswordSuccess(message: message));
    } catch (e) {
      String errorMessage = parseErrorMessage(e);
      emit(ParentUpdatePasswordFailure(error: errorMessage));
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
      String errorMessage = parseErrorMessage(e);
      emit(ParentEmailVerificationFailure(error: errorMessage));
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
      String errorMessage = parseErrorMessage(e);
      emit(ParentResendVerificationFailure(message: errorMessage));
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
      String errorMessage = parseErrorMessage(e);
      emit(ParentCompleteRegistrationFailure(error: errorMessage));
    }
  }

  ///======================================================
  /// handle ParentLoginRequested event
  /// =====================================================
  Future<void> _parentLogin(
      ParentLoginRequested event, Emitter<ParentAuthState> emit) async {
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
      String errorMessage = parseErrorMessage(e);
      emit(ParentLoginFailure(error: errorMessage));
    }
  }

  ///======================================================
  /// handle ParentUpdateProfileRequested event
  /// =====================================================
  Future<void> _parentUpdateProfile(
      ParentUpdateProfileRequested event, Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());
    try {
      final parent = await parentRepository.parentUpdateProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        birthDate: event.birthDate,
        phoneNumber: event.phoneNumber,
        addressPostal: event.addressPostal,
      );

      emit(ParentUpdateProfileSuccess(parent: parent));
    } catch (e) {
      String errorMessage = parseErrorMessage(e);
      emit(ParentUpdateProfileFailure(error: errorMessage));
    }
  }

  ///======================================================
  /// handle ParentGetProfileRequested event
  /// =====================================================
  Future<void> _parentGetProfile(
      ParentGetProfileRequested event, Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());
    try {
      final parent = await parentRepository.getParentProfile();
      emit(ParentGetProfileSuccess(parent: parent));
    } catch (e) {
      String errorMessage = parseErrorMessage(e);
      emit(ParentGetProfileFailure(error: errorMessage));
    }
  }

  ///======================================================
  /// handle ParentLogoutRequested event
  /// =====================================================
  Future<void> _parentLogout(
      ParentLogoutRequested event, Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());
    try {
      final response = await parentRepository.parentLogout();
      await secureStorage.delete(key: 'accessToken');
      emit(AuthUnauthenticated());
      emit(ParentLogoutSuccess(message: response));
    } catch (e) {
      String errorMessage = parseErrorMessage(e);
      emit(ParentLogoutFailure(error: errorMessage));
    }
  }

  //================================ parent child =========================

  ///======================================================
  /// handle ParentChildRegistrationRequested event
  /// =====================================================
  Future<void> _onParentChildRegistration(
      ParentChildRegistrationRequested event,
      Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());
    try {
      final child = await parentRepository.parentChildRegistration(
        firstName: event.firstName,
        lastName: event.lastName,
        birthDate: event.birthDate,
        gender: event.gender,
        schoolLevel: event.schoolLevel,
        password: event.password,
      );
      emit(ParentChildRegistrationSuccess(child: child));
    } catch (e) {
      String errorMessage = parseErrorMessage(e);
      emit(ParentChildRegistrationFailure(error: errorMessage));
    }
  }

  ///======================================================
  /// handle ParentChildGetRequested event
  /// =====================================================
  Future<void> _onParentChildGet(
      ParentChildGetRequested event, Emitter<ParentAuthState> emit) async {
    emit(ParentAuthLoading());
    try {
      final children = await parentRepository.parentChildGet();
      emit(ParentChildGetSuccess(children: children));
    } catch (e) {
      String errorMessage = parseErrorMessage(e);
      emit(ParentChildGetFailure(error: errorMessage));
    }
  }
}

/// Tries to extract a meaningful error message from an exception.
String parseErrorMessage(Object error) {
  // Convert the error to string.
  final errorStr = error.toString();

  // Find the start of a JSON structure.
  final jsonStart = errorStr.indexOf('{');
  if (jsonStart != -1) {
    try {
      final jsonString = errorStr.substring(jsonStart);
      final Map<String, dynamic> errorJson = jsonDecode(jsonString);
      // Return the 'message' field if available.
      if (errorJson.containsKey('message')) {
        return errorJson['message'];
      }
    } catch (_) {
      // If parsing fails, just fall back to errorStr.
    }
  }
  // Fallback: return the original error string.
  return errorStr;
}
