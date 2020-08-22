import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class ProceedOrder extends OrderEvent {
  final List<Stock> items;
  final List<int> amounts;
  final bool isDelivery;

  const ProceedOrder(this.items, this.amounts, this.isDelivery);

  @override
  List<Object> get props => [items, isDelivery];

  @override
  String toString() {
    return 'ProceedOrder{ items: $items, amounts: $amounts, isDelivery: $isDelivery }';
  }
}

class ApproveOrder extends OrderEvent {
  final String orderId;

  const ApproveOrder(this.orderId);

  @override
  List<Object> get props => [orderId];

  @override
  String toString() {
    return 'ApproveOrder{ orderId: $orderId }';
  }
}

class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder(this.orderId);

  @override
  List<Object> get props => [orderId];

  @override
  String toString() {
    return 'CancelOrder{ orderId: $orderId }';
  }
}

class FailOrder extends OrderEvent {
  final String orderId;

  const FailOrder(this.orderId);

  @override
  List<Object> get props => [orderId];

  @override
  String toString() {
    return 'FailOrder{ orderId: $orderId }';
  }
}
