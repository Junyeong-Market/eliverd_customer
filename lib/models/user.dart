import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

class User extends Equatable {
  final int pid;
  final String userId;
  final String password;
  final String nickname;
  final String realname;
  final Coordinate home;
  final Asset profile;

  const User({
    this.pid,
    this.userId,
    this.password,
    this.nickname,
    this.realname,
    this.home,
    this.profile,
  });

  @override
  List<Object> get props =>
      [pid, userId, password, nickname, realname, home, profile];

  @override
  String toString() {
    return 'User{ pid: $pid, userId: $userId, password: $password, nickname: $nickname, realname: $realname, home: $home, profile: $profile }';
  }

  static User fromJson(dynamic json) {
    return User(
      pid: json['pid'],
      userId: json['user_id'],
      password: json['password'],
      nickname: json['nickname'],
      realname: json['realname'],
      home: Coordinate.fromString(json['home']),
      profile: json['profile'] != null ? Asset.fromJson(json['profile']) : null,
    );
  }

  User copyWith(
          {String $password, String $nickname, String $realname, Asset $profile}) =>
      User(
        pid: pid,
        userId: userId,
        password: $password ?? password,
        nickname: $nickname ?? nickname,
        realname: $realname ?? realname,
        profile: $profile ?? profile,
      );

  Map<String, dynamic> toJson() => {
        'pid': pid,
        'user_id': userId,
        'password': password,
        'nickname': nickname,
        'realname': realname,
        'home': home.toJsonString(),
        'profile': profile.toJson(),
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
