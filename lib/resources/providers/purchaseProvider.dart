import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:collection/collection.dart';

import 'package:Eliverd/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseAPIClient {
  static const baseUrl = 'SECRET:8000';
  final http.Client httpClient;

  PurchaseAPIClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<String> getCheckoutByCart(
      List<Stock> items, List<int> amounts, bool isDelivery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> body = [];

    final session = prefs.getString('session');
    final grouped = groupBy(items, (Stock item) => item.store);

    grouped.forEach((store, stocks) {
      body.add({
        'store': store.id,
        'stocks': stocks.map((stock) => {
          'id': stock.id,
          'amount': amounts[items.indexOf(stock)],
        }).toList(),
      });
    });

    final url = '$baseUrl/purchase/?is_delivery=$isDelivery';
    final res = await httpClient.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode(body),
      encoding: Encoding.getByName('utf-8'),
    );

    if (res.statusCode != 201) {
      throw Exception('Error occurred while requesting order');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded)['next_redirect_mobile_url'];

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

  Future<Order> approveOrder(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

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

    return Order.fromJson(json.decode(decoded));
  }

  Future<Order> cancelOrder(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

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

    return Order.fromJson(json.decode(decoded));
  }

  Future<Order> failOrder(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

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

    return Order.fromJson(json.decode(decoded));
  }
}
