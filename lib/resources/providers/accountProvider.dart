import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Eliverd/models/models.dart';

class AccountAPIClient {
  static const baseUrl = 'http://donote.co:8000';
  final http.Client httpClient;

  AccountAPIClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<void> signUpUser(Map<String, dynamic> jsonifiedUser) async {
    final url = '$baseUrl/account/user/';
    final res = await this.httpClient.post(
      url,
      body: jsonifiedUser,
      encoding: Encoding.getByName('application/json; charset=\'utf-8\''),
    );

    if (res.statusCode != 201) {
      throw Exception('Error occurred while registering user');
    }
  }

  Future<String> createSession([String userId, String password]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final currentSession = prefs.getString('session');

    if (currentSession != null) {
      return currentSession;
    } else if (userId == null || password == null) {
      return null;
    }

    final Map<String, dynamic> user = {
      'user_id': prefs.getString('userId') ?? userId,
      'password': prefs.getString('password') ?? password,
    };

    prefs.setString('userId', userId);
    prefs.setString('password', password);

    final url = '$baseUrl/account/session/';
    final res = await this.httpClient.post(
      url,
      body: user,
      encoding: Encoding.getByName('application/json; charset=\'utf-8\''),
    );

    if (res.statusCode != 201) {
      throw Exception('Error occurred while creating session');
    }

    final jsonData = utf8.decode(res.bodyBytes);

    final session = json.decode(jsonData)['session'] as String;

    prefs.setString('session', session);

    return session;
  }

  Future<Map<String, dynamic>> validateSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final currentSession = prefs.getString('session');

    final url = '$baseUrl/account/session/';
    final res = await this.httpClient.get(url,
        headers: {
          'Authorization': currentSession,
        }
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while validating session');
    }

    final jsonData = utf8.decode(res.bodyBytes);

    final userInfo = json.decode(jsonData);

    return userInfo;
  }

  Future<void> deleteSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final currentSession = prefs.getString('session');

    if (currentSession == null) {
      return;
    }

    final url = '$baseUrl/account/session/';
    final res = await this.httpClient.delete(url,
      headers: {
        'Authorization': currentSession,
      }
    );

    await prefs.remove('session');

    if (res.statusCode != 204) {
      throw Exception('Error occurred while deleting session');
    }
  }

  Future<Map<String, dynamic>> validateUser(Map<String, dynamic> jsonifiedUser) async {
    final url = '$baseUrl/account/user/validate/';

    final res = await this.httpClient.post(
      url,
      body: jsonifiedUser,
      encoding: Encoding.getByName('application/json; charset=\'utf-8\''),
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while validating user');
    }

    final jsonData = utf8.decode(res.bodyBytes);

    final data = json.decode(jsonData);

    return data;
  }

  Future<List<User>> searchUser(String keyword) async {
    final url = '$baseUrl/account/user/search/$keyword?is_seller=true/';
    final res = await this.httpClient.get(url);

    if (res.statusCode != 200) {
      throw Exception('Error occurred while searching user');
    }

    final jsonData = utf8.decode(res.bodyBytes);

    final data = json.decode(jsonData)['results'] as List;

    return data.map((rawUser) {
      return User(
        userId: rawUser['user_id'],
        nickname: rawUser['nickname'],
        realname: rawUser['realname'],
        isSeller: rawUser['is_seller'],
      );
    }).toList();
  }
}
