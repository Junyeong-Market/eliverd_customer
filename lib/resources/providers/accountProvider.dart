import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Eliverd/models/models.dart';

class AccountAPIClient {
  static const baseUrl = 'SECRET:8000';
  final http.Client httpClient;

  AccountAPIClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<void> signUpUser(Map<String, dynamic> user) async {
    final url = '$baseUrl/account/user/';
    final res = await this.httpClient.post(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode(user),
          encoding: Encoding.getByName('utf-8'),
        );

    if (res.statusCode != 201) {
      throw Exception('Error occurred while registering user');
    }
  }

  Future<String> createSession([String userId, String password]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (userId == null || password == null) {
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
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode(user),
          encoding: Encoding.getByName('utf-8'),
        );

    if (res.statusCode != 201) {
      throw Exception('Error occurred while creating session');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final session = json.decode(decoded)['session'] as String;

    prefs.setString('session', session);

    return session;
  }

  Future<Map<String, dynamic>> validateSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    if (session == null) {
      return null;
    }

    final url = '$baseUrl/account/session/';
    final res = await this.httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      prefs.remove('session');
      throw Exception('Error occurred while validating session');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded);

    return data;
  }

  Future<void> deleteSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    if (session == null) {
      return;
    }

    final url = '$baseUrl/account/session/';
    final res = await this.httpClient.delete(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 204) {
      throw Exception('Error occurred while deleting session');
    }

    prefs.remove('session');
  }

  Future<Map<String, dynamic>> validateUser(Map<String, dynamic> user) async {
    final url = '$baseUrl/account/user/validate/';

    final res = await this.httpClient.post(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode(user),
          encoding: Encoding.getByName('utf-8'),
        );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while validating user');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded);

    return data;
  }

  Future<List<User>> searchUser(String keyword) async {
    final url = '$baseUrl/account/user/search/$keyword?is_seller=true/';
    final res = await this.httpClient.get(url);

    if (res.statusCode != 200) {
      throw Exception('Error occurred while searching user');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded)['results'] as List;

    return data.map((rawUser) {
      return User(
        userId: rawUser['user_id'],
        nickname: rawUser['nickname'],
        realname: rawUser['realname'],
        isSeller: rawUser['is_seller'],
      );
    }).toList();
  }

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/account/session/';
    final res = await this.httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while fetching user');
    }

    final decoded = utf8.decode(res.bodyBytes);

    return User.fromJson(json.decode(decoded));
  }

  Future<Map<String, dynamic>> updateUser(
      int pid, Map<String, dynamic> updateForm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/account/user/$pid/';
    final res = await this.httpClient.put(
          url,
          headers: {
            HttpHeaders.authorizationHeader: session,
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode(updateForm),
          encoding: Encoding.getByName('utf-8'),
        );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while updating user');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded);

    return data;
  }

  Future<void> closeUser(int pid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/account/user/$pid/';
    final res = await this.httpClient.delete(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 204) {
      throw Exception('Error occurred while closing user account');
    }
  }
}
