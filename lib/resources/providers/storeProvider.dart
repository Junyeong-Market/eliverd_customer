import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:Eliverd/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreAPIClient {
  static const baseUrl = 'SECRET:8000';
  final http.Client httpClient;

  StoreAPIClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Store>> fetchStoreListByLocation(Coordinate coordinate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url =
        '$baseUrl/store/by-radius/?lat=${coordinate.lat}&lng=${coordinate.lng}&distance=1000.0';
    final res = await this.httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while fetching store list by location');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded) as List;

    return data
        .map(
          (rawStore) => Store(
            id: rawStore['id'],
            name: rawStore['name'],
            description: rawStore['description'],
            location: Store.getStoreCoordinate(rawStore['location']),
          ),
        )
        .toList();
  }

  Future<List<Stock>> fetchStock(Store store) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/store/${store.id}/stocks/';
    final res = await this.httpClient.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while fetching all stocks on your store');
    }

    final decoded = utf8.decode(res.bodyBytes);

    final data = json.decode(decoded)['results'] as List;

    final stocks = data.map((rawStock) {
      return Stock(
        store: store,
        product: Product.fromJson(rawStock['product']),
        price: rawStock['price'],
        amount: rawStock['amount'],
      );
    }).toList();

    return stocks;
  }
}
