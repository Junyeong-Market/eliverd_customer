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

  Future<Order> approveOrder(String orderId) async {
    final data = purchaseAPIClient.approveOrder(orderId);

    return data;
  }

  Future<Order> cancelOrder(String orderId) async {
    final data = purchaseAPIClient.cancelOrder(orderId);

    return data;
  }

  Future<Order> failOrder(String orderId) async {
    final data = purchaseAPIClient.failOrder(orderId);

    return data;
  }
}