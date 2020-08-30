import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class GrantAuthentication extends AuthenticationEvent {
  final String userId;
  final String password;

  const GrantAuthentication(this.userId, this.password);

  @override
  List<Object> get props => [userId, password];

  @override
  String toString() {
    return 'SignInAuthentication{ userId: $userId, password: $password }';
  }
}

class RevokeAuthentication extends AuthenticationEvent {}

class CheckAuthentication extends AuthenticationEvent {}

