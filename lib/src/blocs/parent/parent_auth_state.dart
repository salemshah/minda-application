import 'package:minda_application/src/models/child/child_model.dart';

import '../../models/parent/parent_model.dart';

abstract class ParentAuthState {}

class ParentAuthInitial extends ParentAuthState {}

class ParentAuthLoading extends ParentAuthState {}

class AuthAuthenticated extends ParentAuthState {}

class AuthUnauthenticated extends ParentAuthState {}

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

  ParentLoginSuccess(
      {required this.parent,
      required this.message,
      required this.accessToken,
      required this.refreshToken});
}

///==================================================================
/// State used when parent update profile  succeeds
///==================================================================
class ParentUpdateProfileSuccess extends ParentAuthState {
  final ParentModel parent;

  ParentUpdateProfileSuccess({
    required this.parent,
  });
}

///==================================================================
/// State used when parent update profile failure
///==================================================================
class ParentUpdateProfileFailure extends ParentAuthState {
  final String error;

  ParentUpdateProfileFailure({required this.error});
}

///==================================================================
/// State used when parent login failure
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
/// State used when parent complete registration failure
///==================================================================
class ParentCompleteRegistrationFailure extends ParentAuthState {
  final String error;

  ParentCompleteRegistrationFailure({required this.error});
}

///==================================================================
/// State used when parent logout succeeds
///==================================================================
class ParentLogoutSuccess extends ParentAuthState {
  final String message;

  ParentLogoutSuccess({required this.message});
}

///==================================================================
/// State used when get profile succeeds
///==================================================================
class ParentGetProfileSuccess extends ParentAuthState {
  final ParentModel parent;

  ParentGetProfileSuccess({required this.parent});
}

///==================================================================
/// State used when get profile failure
///==================================================================
class ParentGetProfileFailure extends ParentAuthState {
  final String error;

  ParentGetProfileFailure({required this.error});
}

///==================================================================
/// State used when parent logout failure failure
///==================================================================
class ParentLogoutFailure extends ParentAuthState {
  final String error;

  ParentLogoutFailure({required this.error});
}

///==================================================================
/// State used when get profile succeeds
///==================================================================
class ParentUpdatePasswordSuccess extends ParentAuthState {
  final String message;

  ParentUpdatePasswordSuccess({required this.message});
}

///==================================================================
/// State used when get profile failure
///==================================================================
class ParentUpdatePasswordFailure extends ParentAuthState {
  final String error;

  ParentUpdatePasswordFailure({required this.error});
}

// ======================================= parent child ========================

///==================================================================
/// State used when  parent child registration succeeds
///==================================================================
class ParentChildRegistrationSuccess extends ParentAuthState {
  final ChildModel child;

  ParentChildRegistrationSuccess({
    required this.child
  });
}

///==================================================================
/// State used when parent child registration failure
///==================================================================
class ParentChildRegistrationFailure extends ParentAuthState {
  final String error;

  ParentChildRegistrationFailure({required this.error});
}

///==================================================================
/// State used when  parent child Get succeeds
///==================================================================
class ParentChildGetSuccess extends ParentAuthState {
  final List<ChildModel> children;
  ParentChildGetSuccess({
    required this.children
  });
  List<Object?> get props => [children];
}

///==================================================================
/// State used when parent child Get failure
///==================================================================
class ParentChildGetFailure extends ParentAuthState {
  final String error;

  ParentChildGetFailure({required this.error});

}
