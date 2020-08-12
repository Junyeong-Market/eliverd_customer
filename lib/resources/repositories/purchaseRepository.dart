import 'dart:async';

import 'package:meta/meta.dart';

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/models/models.dart';

class PurchaseRepository {
  final PurchaseAPIClient purchaseAPIClient;

  PurchaseRepository({@required this.purchaseAPIClient})
      : assert(PurchaseAPIClient != null);

  Future<Map<String, dynamic>> getCheckoutByCart(List<Map<String, dynamic>> carts) async {
    final data = purchaseAPIClient.getCheckoutByCart(carts);

    return data;
  }

  Future<Order> getOrderInfo(String orderId) async {
    final data = purchaseAPIClient.getOrderInfo(orderId);

    return data;
  }
}