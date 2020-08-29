import 'package:Eliverd/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserInfoFetched extends UserState {
  final User user;
  final int count;
  final int total;

  const UserInfoFetched({@required this.user, @required this.count, @required this.total});

  @override
  List<Object> get props => [user, count, total];
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