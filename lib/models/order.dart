import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

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
  final List<OrderedStock> stocks;
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
        poid: json['poid'],
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
        'stocks': stocks.map((OrderedStock stock) => stock.toJson()).toList(),
        'status': status,
        'is_delivery': isDelivery,
      };
}

class OrderedStock extends Equatable {
  final int osid;
  final int amount;
  final int status;
  final Stock stock;

  const OrderedStock({this.osid, this.amount, this.status, this.stock});

  @override
  List<Object> get props => [osid, amount, status, stock];

  @override
  String toString() {
    return 'OrderedStock{soid: $osid, amount: $amount, status: $status, stock: $stock}';
  }

  static OrderedStock fromJson(dynamic json) => OrderedStock(
        osid: json['osid'],
        amount: json['amount'],
        status: json['status'],
        stock: Stock.fromJsonWithoutStore(json['stock']),
      );

  Map<String, dynamic> toJson() => {
        'osid': osid,
        'amount': amount,
        'status': status,
        'stock': stock.toJson(),
      };
}
