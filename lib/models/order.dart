import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

class Order extends Equatable {
  final int id;
  final String tid;
  final User customer;
  final List<int> partials;
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
}
