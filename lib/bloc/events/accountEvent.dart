import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class ValidateAccount extends AccountEvent {
  final Map<String, dynamic> jsonifiedUser;

  const ValidateAccount(this.jsonifiedUser);

  @override
  List<Object> get props => [jsonifiedUser];

  @override
  String toString() {
    return 'AccountValidated{ jsonifiedUser: $jsonifiedUser }';
  }
}

class CreateAccount extends AccountEvent {
  final Map<String, dynamic> jsonifiedUser;

  const CreateAccount(this.jsonifiedUser);

  @override
  List<Object> get props => [jsonifiedUser];

  @override
  String toString() {
    return 'AccountCreated{ jsonifiedUser: $jsonifiedUser }';
  }
}
