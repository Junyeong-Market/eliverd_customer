import 'dart:convert';

import 'package:Eliverd/models/models.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int id;
  final String tid;
  final User customer;
  final List<PartialOrder> partials;
  final String status;
  final bool isDelivery;

  Order(
      {this.id,
      this.tid,
      this.customer,
      this.partials,
      this.status,
      this.isDelivery});

  @override
  List<Object> get props => [id, tid, customer, partials, status, isDelivery];

  static Order fromJson(dynamic json) => Order(
        id: json['oid'],
        tid: json['tid'],
        customer: User.fromJson(json['customer']),
        partials: json['partials']
            .map<PartialOrder>((partial) => PartialOrder.fromJson(partial))
            .toList(),
        status: json['status'],
        isDelivery: json['is_delivery'],
      );

  @override
  String toString() {
    return 'Order{id: $id, tid: $tid, customer: $customer, partials: $partials, status: $status, isDelivery: $isDelivery}';
  }

  Map<String, dynamic> toJson() => {
        'oid': id,
        'tid': tid,
        'customer': customer.toJson(),
        'partials':
            partials.map((PartialOrder partial) => partial.toJson()).toList(),
        'status': status,
        'is_delivery': isDelivery,
      };
}

class PartialOrder extends Equatable {
  final int poid;
  final Store store;
  final OrderedStock stocks;
  final String status;
  final bool isDelivery;

  const PartialOrder(
      {this.poid, this.store, this.stocks, this.status, this.isDelivery});

  @override
  List<Object> get props => [poid, store, stocks, status, isDelivery];

  @override
  String toString() {
    return 'PartialOrder{poid: $poid, store: $store, stocks: $stocks, status: $status, isDelivery: $isDelivery}';
  }

  static PartialOrder fromJson(dynamic json) => PartialOrder(
        poid: json['id'],
        store: Store.fromJson(json['store']),
        stocks: json['stocks']
            .map<OrderedStock>((stock) => OrderedStock.fromJson(stock))
            .toList(),
        status: json['status'],
        isDelivery: json['is_delivery'],
      );

  Map<String, dynamic> toJson() => {
        'poid': poid,
        'store': store.toJson(),
        'stocks': stocks.toJson(),
        'status': status,
        'is_delivery': isDelivery,
      };
}

class OrderedStock extends Equatable {
  final int soid;
  final int amount;
  final String status;
  final Stock stock;

  const OrderedStock({this.soid, this.amount, this.status, this.stock});

  @override
  List<Object> get props => [soid, amount, status, stock];

  static OrderedStock fromJson(dynamic json) => OrderedStock(
        soid: json['soid'],
        amount: json['amount'],
        status: json['status'],
        stock: Stock.fromJson(json['stock']),
      );

  Map<String, dynamic> toJson() => {
        'soid': soid,
        'amount': amount,
        'status': status,
        'stock': stock.toJson(),
      };
}
