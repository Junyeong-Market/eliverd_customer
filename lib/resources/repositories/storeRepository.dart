import 'dart:async';

import 'package:meta/meta.dart';

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/models/models.dart';

class StoreRepository {
  final StoreAPIClient storeAPIClient;

  StoreRepository({@required this.storeAPIClient})
      : assert(storeAPIClient != null);

  Future<List<Store>> fetchStores(Coordinate coordinate) async {
    final stores = await storeAPIClient.fetchStoreListByLocation(coordinate);

    return stores;
  }

  Future<List<Stock>> fetchStocks(Store store) async {
    final stocks = await storeAPIClient.fetchStock(store);

    return stocks;
  }

  Future<List<Stock>> fetchSearchedItems(Coordinate coordinate, String name, [String category]) async {
    final items = await storeAPIClient.fetchSearchedItems(coordinate, name, category);

    return items;
  }

  Future<List<Stock>> fetchEventItems(Coordinate coordinate) async {
    final items = await storeAPIClient.fetchEventItems(coordinate);

    return items;
  }
}