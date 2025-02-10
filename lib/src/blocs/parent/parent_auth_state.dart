abstract class ParentAuthState {}

class ParentAuthInitial extends ParentAuthState {}

class ParentAuthLoading extends ParentAuthState {}

class ParentAuthSuccess extends ParentAuthState {
  final String message;

  ParentAuthSuccess({required this.message});
}

class ParentAuthFailure extends ParentAuthState {
  final String error;

  ParentAuthFailure({required this.error});
}
