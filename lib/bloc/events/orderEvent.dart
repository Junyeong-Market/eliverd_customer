import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class ProceedOrder extends OrderEvent {}

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
