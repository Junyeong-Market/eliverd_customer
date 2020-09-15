import 'dart:async';

import 'package:meta/meta.dart';

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/models/models.dart';

class DeliveryRepository {
  final DeliveryAPIClient deliveryAPIClient;

  DeliveryRepository({@required this.deliveryAPIClient})
      : assert(deliveryAPIClient != null);

  Future<PartialOrder> changeDeliveryState(String transportToken) async {
    final data = await deliveryAPIClient.changeDeliveryState(transportToken);

    return data;
  }
}