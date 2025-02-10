
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

/// Event for parent login.
class ParentLoginRequested extends ParentAuthEvent {
  final String email;
  final String password;

  ParentLoginRequested({
    required this.email,
    required this.password,
  });
}
