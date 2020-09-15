import 'dart:async';

import 'package:meta/meta.dart';

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/models/models.dart';

class PurchaseRepository {
  final PurchaseAPIClient purchaseAPIClient;

  PurchaseRepository({@required this.purchaseAPIClient})
      : assert(purchaseAPIClient != null);

  Future<String> createOrder(
      List<Stock> items, List<int> amounts, Coordinate shippingDestination) async {
    final data = await purchaseAPIClient.createOrder(items, amounts, shippingDestination);

    return data;
  }

  Future<Order> fetchOrder(String orderId) async {
    final data = await purchaseAPIClient.fetchOrder(orderId);

    return data;
  }

  Future<List<Order>> fetchOrdersFromUser(int pid, [int page]) async {
    final data = await purchaseAPIClient.fetchOrdersFromUser(pid, page ?? 1);

    return data;
  }

  Future<Order> approveOrder(String url) async {
    final data = await purchaseAPIClient.approveOrder(url);

    return data;
  }

  Future<Order> cancelOrder(String url) async {
    final data = await purchaseAPIClient.cancelOrder(url);

    return data;
  }

  Future<Order> failOrder(String url) async {
    final data = await purchaseAPIClient.failOrder(url);

    return data;
  }

  Future<String> continueOrder(int orderId) async {
    final data = await purchaseAPIClient.continueOrder(orderId);

    return data;
  }
}