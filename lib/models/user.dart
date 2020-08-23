import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int pid;
  final String userId;
  final String password;
  final String nickname;
  final String realname;
  final bool isSeller;

  const User(
      {this.pid,
      this.userId,
      this.password,
      this.nickname,
      this.realname,
      this.isSeller});

  @override
  List<Object> get props =>
      [pid, userId, password, nickname, realname, isSeller];

  @override
  String toString() {
    return 'User{ pid: $pid, userId: $userId, password: $password, nickname: $nickname, realname: $realname, isSeller: $isSeller }';
  }

  static User fromJson(dynamic json) {
    return User(
      pid: json['pid'],
      userId: json['user_id'],
      password: json['password'],
      nickname: json['nickname'],
      isSeller: json['is_seller'],
    );
  }

  Map<String, dynamic> toJson() => {
    'pid': pid,
    'user_id': userId,
    'password': password,
    'nickname': nickname,
    'is_seller': isSeller,
  };
}

class Session extends Equatable {
  final int id;
  final int pid;
  final DateTime expireAt;

  const Session({this.id, this.pid, this.expireAt});

  @override
  List<Object> get props => [id, pid, expireAt];

  @override
  String toString() {
    return 'Session{ id: $id, pid: $pid, expireAt: $expireAt }';
  }
}
