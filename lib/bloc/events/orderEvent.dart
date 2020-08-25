import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchOrder extends OrderEvent {}

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
  final String url;

  const ApproveOrder(this.url);

  @override
  List<Object> get props => [url];

  @override
  String toString() {
    return 'ApproveOrder{ orderId: $url }';
  }
}

class CancelOrder extends OrderEvent {
  final String url;

  const CancelOrder(this.url);

  @override
  List<Object> get props => [url];

  @override
  String toString() {
    return 'CancelOrder{ orderId: $url }';
  }
}

class FailOrder extends OrderEvent {
  final String url;

  const FailOrder(this.url);

  @override
  List<Object> get props => [url];

  @override
  String toString() {
    return 'FailOrder{ orderId: $url }';
  }
}
