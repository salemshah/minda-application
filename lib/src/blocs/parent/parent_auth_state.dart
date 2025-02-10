import '../../models/parent_model.dart';

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

class ParentEmailVerificationSuccess extends ParentAuthState {

}

/// State used when parent login succeeds and you want to pass a ParentModel.
class ParentLoginSuccess extends ParentAuthState {
  final ParentModel parent;

  ParentLoginSuccess({required this.parent});
}
