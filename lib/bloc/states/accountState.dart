import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountOnCreate extends AccountState {}

class AccountValidateFailed extends AccountState {
  final Map<String, dynamic> jsonifiedValidation;

  const AccountValidateFailed(this.jsonifiedValidation);

  @override
  List<Object> get props => [jsonifiedValidation];
}

class AccountDoneCreate extends AccountState {}

class AccountError extends AccountState {}

