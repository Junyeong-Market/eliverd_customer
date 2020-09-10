import 'dart:async';

import 'package:meta/meta.dart';

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/models/models.dart';

class AccountRepository {
  final AccountAPIClient accountAPIClient;

  AccountRepository({@required this.accountAPIClient})
      : assert(accountAPIClient != null);

  Future<void> signUpUser(Map<String, dynamic> jsonifiedUser) async {
    await accountAPIClient.signUpUser(jsonifiedUser);
  }

  Future<Map<String, dynamic>> validateUser(Map<String, dynamic> jsonifiedUser) async {
    final validation = await accountAPIClient.validateUser(jsonifiedUser);

    return validation;
  }

  Future<User> getUser() async {
    final user = await accountAPIClient.getUser();

    return user;
  }

  Future<Map<String, dynamic>> fetchUserOrderSummary(int pid, [int month]) async {
    final summary = await accountAPIClient.fetchUserOrderSummary(pid, month);

    return summary;
  }

  Future<List<PartialOrder>> fetchProcessingDeliveries(int pid, [int page]) async {
    final deliveries = await accountAPIClient.fetchProcessingDeliveries(pid, page);

    return deliveries;
  }

  Future<Map<String, dynamic>> updateUser(int pid, Map<String, dynamic> updateForm) async {
    final data = await accountAPIClient.updateUser(pid, updateForm);

    return data;
  }

  Future<void> closeUser(int pid) async {
    await accountAPIClient.closeUser(pid);
  }

  Future<List<User>> searchUser(String keyword) async {
    final users = await accountAPIClient.searchUser(keyword);

    return users;
  }

  Future<String> createSession([String userId, String password]) async {
    final session = await accountAPIClient.createSession(userId, password);

    return session;
  }

  Future<User> validateSession() async {
    final user = await accountAPIClient.validateSession();

    return user;
  }

  Future<void> deleteSession() async {
    await accountAPIClient.deleteSession();
  }
}