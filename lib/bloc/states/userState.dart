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
  final int count;
  final int total;

  const UserFetched({@required this.user, @required this.count, @required this.total});

  @override
  List<Object> get props => [user, count, total];
}

class UserError extends UserState {}