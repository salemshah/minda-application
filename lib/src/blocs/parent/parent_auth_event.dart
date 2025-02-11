/// Base class for parent authentication events.
abstract class ParentAuthEvent {}

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

/// Event for parent login.
class ParentLoginRequested extends ParentAuthEvent {
  final String email;
  final String password;

  ParentLoginRequested({
    required this.email,
    required this.password,
  });
}
