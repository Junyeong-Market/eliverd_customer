import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

class Coordinate extends Equatable {
  final double lat;
  final double lng;

  @override
  List<Object> get props => [lat, lng];

  const Coordinate({@required this.lat, @required this.lng});

  @override
  String toString() {
    return 'Coordinate{ lat: $lat, lng: $lng }';
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };

  String toJsonString() {
    return 'SRID=4326;POINT($lat $lng)';
  }

  static Coordinate fromString(String location) {
    if (location == null || location.isEmpty) {
      return null;
    }

    final rawCoordinate = location
        .substring(location.indexOf('(') + 1, location.indexOf(')'))
        .split(' ');

    return Coordinate(
      lat: double.parse(rawCoordinate[0]),
      lng: double.parse(rawCoordinate[1]),
    );
  }
}

class Store extends Equatable {
  final int id;
  final String name;
  final String description;
  final List<User> registerers;
  final String registeredNumber;
  final Coordinate location;

  const Store(
      {this.id,
      this.name,
      this.description,
      this.registerers,
      this.registeredNumber,
      this.location});

  @override
  List<Object> get props =>
      [id, name, description, registerers, registeredNumber, location];

  @override
  String toString() {
    return 'Store { id: $id, name: $name, description: $description, registerers: $registerers, registeredNumber: $registeredNumber, location: $location}';
  }

  static Store fromJson(dynamic json) => Store(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        registerers: json['registerer']
            .map<User>((registerer) => User.fromJson(registerer))
            .toList(),
        registeredNumber: json['registered_number'],
        location: Coordinate.fromString(json['location']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'registerer':
            registerers.map((User registerer) => registerer.toJson()).toList(),
        'registered_number': registeredNumber,
        'location': location.toJsonString(),
      };
}

class Stock extends Equatable {
  final int id;
  final Store store;
  final Product product;
  final int price;
  final int amount;

  const Stock({this.id, this.store, this.product, this.price, this.amount});

  @override
  List<Object> get props => [id, store, product, price, amount];

  @override
  String toString() =>
      'Stock{ id: $id, store: $store, product: $product, price: $price, amount: $amount }';

  static Stock fromJson(dynamic json, [Store store]) => Stock(
        id: json['id'],
        store: store ?? Store.fromJson(json['store']),
        product: Product.fromJson(json['product']),
        price: json['price'],
        amount: json['amount'],
      );

  static Stock fromJsonWithoutStore(dynamic json) => Stock(
        id: json['id'],
        product: Product.fromJson(json['product']),
        price: json['price'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'store': store.toJson(),
        'product': product,
        'price': price,
        'amount': amount,
      };
}
