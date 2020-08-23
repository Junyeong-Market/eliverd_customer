import 'dart:async';

import 'package:meta/meta.dart';

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/models/models.dart';

class PurchaseRepository {
  final PurchaseAPIClient purchaseAPIClient;

  PurchaseRepository({@required this.purchaseAPIClient})
      : assert(PurchaseAPIClient != null);

  Future<String> getCheckoutByCart(
      List<Stock> items, List<int> amounts, bool isDelivery) async {
    final data = purchaseAPIClient.getCheckoutByCart(items, amounts, isDelivery);

    return data;
  }

  Future<Order> getOrderInfo(String orderId) async {
    final data = purchaseAPIClient.getOrderInfo(orderId);

    return data;
  }

  Future<Order> approveOrder(String url) async {
    final data = purchaseAPIClient.approveOrder(url);

    return data;
  }

  Future<Order> cancelOrder(String url) async {
    final data = purchaseAPIClient.cancelOrder(url);

    return data;
  }

  Future<Order> failOrder(String url) async {
    final data = purchaseAPIClient.failOrder(url);

    return data;
  }
}