import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:Eliverd/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseAPIClient {
  static const baseUrl = 'SECRET:8000';
  final http.Client httpClient;

  PurchaseAPIClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Map<String, dynamic>> getCheckoutByCart(
      List<Map<String, dynamic>> carts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/purchase/';
    final res = await httpClient.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode(carts),
      encoding: Encoding.getByName('utf-8'),
    );

    if (res.statusCode != 200) {
      throw Exception('Error occured while processing carts');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded);

    return data;
  }

  Future<Order> getOrderInfo(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/purchase/$orderId';
    final res = await httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred when fetching order information');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded) as Order;

    return data;
  }

  Future<Order> approveOrder(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/purchase/$orderId/approve/';
    final res = await httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred when notifying approved order to server');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded) as Order;

    return data;
  }

  Future<Order> cancelOrder(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/purchase/$orderId/cancel/';
    final res = await httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred when notifying canceled order to server');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded) as Order;

    return data;
  }

  Future<Order> failOrder(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/purchase/$orderId/fail/';
    final res = await httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred when notifying failed order to server');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded) as Order;

    return data;
  }
}
