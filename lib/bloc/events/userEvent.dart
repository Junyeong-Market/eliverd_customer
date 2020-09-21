import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUserInfo extends UserEvent {
  final int month;

  const FetchUserInfo({@required this.month});

  @override
  List<Object> get props => [month];
}

class UpdateUser extends UserEvent {
  final String nickname;
  final String realname;
  final File image;

  const UpdateUser({@required this.nickname, this.realname, this.image});

  @override
  List<Object> get props => [nickname, realname, image];
}

class CloseUserAccount extends UserEvent {}
