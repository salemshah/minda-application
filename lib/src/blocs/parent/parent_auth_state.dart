import '../../models/parent/parent_model.dart';

abstract class ParentAuthState {}

class ParentAuthInitial extends ParentAuthState {}

class ParentAuthLoading extends ParentAuthState {}
///==================================================================
/// State used when the parent registration succeeds
/// =================================================================
class ParentRegistrationSuccess extends ParentAuthState {
  final String message;
  final String email;

  ParentRegistrationSuccess({required this.message, required this.email});
}
///==================================================================
/// State used when the parent registration failed
///==================================================================
class ParentRegistrationFailure extends ParentAuthState {
  final String error;

  ParentRegistrationFailure({required this.error});
}
///==================================================================
/// State used when the resend email verification succeeds
///==================================================================
class ParentResendVerificationSuccess extends ParentAuthState {
  final String message;

  ParentResendVerificationSuccess({required this.message});
}
///==================================================================
/// State used when the resend email verification failed
///==================================================================
class ParentResendVerificationFailure extends ParentAuthState {
  final String message;

  ParentResendVerificationFailure({required this.message});
}
///==================================================================
/// State used when the email verification succeeds
///==================================================================
class ParentEmailVerificationSuccess extends ParentAuthState {
  final String message;

  ParentEmailVerificationSuccess({required this.message});
}
///==================================================================
/// State used when the email verification failed
///==================================================================
class ParentEmailVerificationFailure extends ParentAuthState {
  final String error;

  ParentEmailVerificationFailure({required this.error});
}
///==================================================================
/// State used when parent login succeeds
///==================================================================
class ParentLoginSuccess extends ParentAuthState {
  final ParentModel parent;
  final String accessToken;
  final String refreshToken;
  final String message;

  ParentLoginSuccess({required this.parent, required this.message, required this.accessToken, required this.refreshToken});
}
///==================================================================
/// State used when parent login succeeds
///==================================================================
class ParentLoginFailure extends ParentAuthState {
  final String error;

  ParentLoginFailure({required this.error});
}
///==================================================================
/// State used when parent complete succeeds
///==================================================================
class ParentCompleteRegistrationSuccess extends ParentAuthState {
  final ParentModel parent;
  final String message;

  ParentCompleteRegistrationSuccess(
      {required this.parent, required this.message});
}
///==================================================================
/// State used when parent complete registration succeeds
///==================================================================
class ParentCompleteRegistrationFailure extends ParentAuthState {
  final String error;

  ParentCompleteRegistrationFailure({required this.error});
}
