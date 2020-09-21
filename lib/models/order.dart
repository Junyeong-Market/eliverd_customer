import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

class OrderStatus {
  // ignore: non_constant_identifier_names
  static const PENDING = 'pending';

  // ignore: non_constant_identifier_names
  static const PROCESSED = 'processed';

  // ignore: non_constant_identifier_names
  static const CANCELED = 'canceled';

  // ignore: non_constant_identifier_names
  static const FAILED = 'failed';

  static formatOrderStatus(String status) {
    switch (status) {
      case PENDING:
        return '주문 처리 중';
        break;
      case PROCESSED:
        return '주문 완료';
        break;
      case CANCELED:
        return '주문 취소';
        break;
      case CANCELED:
        return '주문 실패';
        break;
    }

    return '주문 보류';
  }
}

class DeliveryStatus {
  // ignore: non_constant_identifier_names
  static const PENDING = 'pending';

  // ignore: non_constant_identifier_names
  static const READY = 'ready';

  // ignore: non_constant_identifier_names
  static const DELIVERING = 'delivering';

  // ignore: non_constant_identifier_names
  static const DELIVERED = 'delivered';

  // ignore: non_constant_identifier_names
  static const CANCELED = 'canceled';

  static formatDeliveryStatus(String status) {
    switch (status) {
      case PENDING:
        return '결제 대기 중';
        break;
      case READY:
        return '배송 전';
        break;
      case DELIVERING:
        return '배송 중';
        break;
      case DELIVERED:
        return '배송 완료';
        break;
      case CANCELED:
        return '배송 취소';
        break;
    }

    return '배송 보류';
  }
}

class Order extends Equatable {
  final int id;
  final String tid;
  final User customer;
  final List<PartialOrder> partials;
  final DateTime createdAt;
  final String status;
  final Coordinate destination;
  final bool exclude;

  Order(
      {this.id,
      this.tid,
      this.customer,
      this.partials,
      this.createdAt,
      this.status,
      this.destination,
      this.exclude});

  @override
  List<Object> get props =>
      [id, tid, customer, partials, createdAt, status, destination, exclude];

  static Order fromJson(dynamic json) => Order(
        id: json['oid'],
        tid: json['tid'],
        customer: User.fromJson(json['customer']),
        partials: json['partials']
            .map<PartialOrder>((partial) => PartialOrder.fromJson(partial))
            .toList(),
        createdAt: DateTime.parse(json['created_at']),
        status: json['status'],
        destination: Coordinate.fromString(json['destination']),
        exclude: json['exclude'],
      );

  @override
  String toString() {
    return 'Order{id: $id, tid: $tid, customer: $customer, partials: $partials, createdAt: $createdAt, status: $status, destination: $destination, exclude: $exclude }';
  }

  Map<String, dynamic> toJson() => {
        'oid': id,
        'tid': tid,
        'customer': customer.toJson(),
        'partials':
            partials.map((PartialOrder partial) => partial.toJson()).toList(),
        'created_at': createdAt.toIso8601String(),
        'status': status,
        'destination': destination.toJsonString(),
        'exclude': exclude,
      };
}

class PartialOrder extends Equatable {
  final int poid;
  final Store store;
  final List<OrderedStock> stocks;
  final User transport;
  final DateTime createdAt;
  final String status;
  final Coordinate destination;
  final String transportToken;

  const PartialOrder(
      {this.poid,
      this.store,
      this.stocks,
      this.transport,
      this.createdAt,
      this.status,
      this.destination,
      this.transportToken});

  @override
  List<Object> get props => [
        poid,
        store,
        stocks,
        transport,
        status,
        createdAt,
        destination,
        transportToken
      ];

  @override
  String toString() {
    return 'PartialOrder{ poid: $poid, store: $store, stocks: $stocks, transport: $transport, status: $status, createdAt: $createdAt, destination: $destination, transportToken: $transportToken }';
  }

  static PartialOrder fromJson(dynamic json) => PartialOrder(
        poid: json['poid'],
        store: Store.fromJson(json['store']),
        stocks: json['stocks']
            .map<OrderedStock>((stock) => OrderedStock.fromJson(stock))
            .toList(),
        transport:
            json['transport'] != null ? User.fromJson(json['transport']) : null,
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
        destination: Coordinate.fromString(json['destination']),
        transportToken: json['transport_token'],
      );

  Map<String, dynamic> toJson() => {
        'poid': poid,
        'store': store.toJson(),
        'stocks': stocks.map((OrderedStock stock) => stock.toJson()).toList(),
        'transport': transport.toJson(),
        'created_at': createdAt.toIso8601String(),
        'status': status,
        'destination': destination.toJsonString(),
        'transport_token': transportToken,
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
