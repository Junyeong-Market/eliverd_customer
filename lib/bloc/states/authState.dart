import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class NotAuthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthenticationError extends AuthenticationState {
  final String errorMessage;

  const AuthenticationError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
