import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUser extends UserEvent {}

class UpdateUser extends UserEvent {
  final String nickname;
  final String realname;
  final bool isSeller;

  const UpdateUser({@required this.nickname, this.realname, this.isSeller});

  @override
  List<Object> get props => [nickname, realname, isSeller];
}

class CloseUserAccount extends UserEvent {}