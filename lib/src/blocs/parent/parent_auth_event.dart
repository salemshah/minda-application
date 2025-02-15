import 'package:minda_application/src/models/parent/parent_model.dart';

/// Base class for parent authentication events.
abstract class ParentAuthEvent {}

class CheckParentTokenExpiration extends ParentAuthEvent {}

/// Event for parent registration.
class ParentRegisterRequested extends ParentAuthEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  ParentRegisterRequested({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });
}

/// event for parent email verification code
class ParentEmailVerificationRequested extends ParentAuthEvent {
  final String code;

  ParentEmailVerificationRequested({required this.code});
}

/// event for parent resend email verification code
class ParentResendEmailVerificationRequested extends ParentAuthEvent {
  final String email;

  ParentResendEmailVerificationRequested({
    required this.email,
  });
}

/// event for parent complete registration
class ParentCompleteRegistrationRequested extends ParentAuthEvent {
  final String birthDate;
  final String phoneNumber;
  final String addressPostal;

  ParentCompleteRegistrationRequested({
    required this.birthDate,
    required this.phoneNumber,
    required this.addressPostal,
  });
}

/// event for ParentUpdateProfileRequested
class ParentUpdateProfileRequested extends ParentAuthEvent {
  final String firstName;
  final String lastName;
  final String birthDate;
  final String phoneNumber;
  final String addressPostal;

  ParentUpdateProfileRequested({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.phoneNumber,
    required this.addressPostal,
  });
}


/// Event for parent login.
class ParentLoginRequested extends ParentAuthEvent {
  final String email;
  final String password;

  ParentLoginRequested({
    required this.email,
    required this.password,
  });
}

class ParentGetProfileRequested extends ParentAuthEvent {
  ParentGetProfileRequested();
}

class ParentLogoutRequested extends ParentAuthEvent {
  ParentLogoutRequested();
}

/// event for ParentUpdatePasswordRequested
class ParentUpdatePasswordRequested extends ParentAuthEvent {
  final String oldPassword;
  final String newPassword;

  ParentUpdatePasswordRequested({
    required this.oldPassword,
    required this.newPassword,
  });
}

