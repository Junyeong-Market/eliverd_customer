import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:Eliverd/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryAPIClient {
  static const baseUrl = 'SECRET:8000';
  final http.Client httpClient;

  DeliveryAPIClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<PartialOrder> changeDeliveryState(String transportToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/delivery/?token=$transportToken';
    final res = await httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while changing delivery state');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded);

    return PartialOrder.fromJson(data);
  }
}
