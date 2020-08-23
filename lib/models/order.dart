import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int id;
  final String tid;
  final int customer;
  final List<dynamic> partials;
  final String status;
  final bool isDelivery;

  Order({this.id, this.tid, this.customer, this.partials, this.status,
      this.isDelivery});

  @override
  List<Object> get props => [id, tid, customer, partials, status, isDelivery];

  static Order fromJson(dynamic json) => Order(
        id: json['oid'],
        tid: json['tid'],
        customer: json['customer'],
        partials: json['partials'],
        status: json['status'],
        isDelivery: json['is_delivery'],
      );

  @override
  String toString() {
    return 'Order{id: $id, tid: $tid, customer: $customer, partials: $partials, status: $status, isDelivery: $isDelivery}';
  }
}
