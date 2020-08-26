import 'package:Eliverd/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserFetched extends UserState {
  final User user;

  const UserFetched(this.user);

  @override
  List<Object> get props => [user];
}

class UserUpdated extends UserState {
  final String nickname;
  final String realname;
  final bool isSeller;

  const UserUpdated({@required this.nickname, this.realname, this.isSeller});

  @override
  List<Object> get props => [nickname, realname, isSeller];
}

class UserClosed extends UserState {}

class UserError extends UserState {}