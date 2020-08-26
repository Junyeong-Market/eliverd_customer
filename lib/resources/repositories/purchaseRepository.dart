import 'dart:async';

import 'package:meta/meta.dart';

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/models/models.dart';

class PurchaseRepository {
  final PurchaseAPIClient purchaseAPIClient;

  PurchaseRepository({@required this.purchaseAPIClient})
      : assert(PurchaseAPIClient != null);

  Future<String> getCheckoutByCart(
      List<Stock> items, List<int> amounts, Coordinate shippingDestination) async {
    final data = await purchaseAPIClient.getCheckoutByCart(items, amounts, shippingDestination);

    return data;
  }

  Future<Order> getOrderInfo(String orderId) async {
    final data = await purchaseAPIClient.getOrderInfo(orderId);

    return data;
  }

  Future<List<Order>> fetchOrder(int pid, [int page]) async {
    final data = await purchaseAPIClient.fetchOrder(pid, page ?? 1);

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
}