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

  Store copyWith(
          {int id,
          String name,
          String description,
          List<User> registerers,
          String registeredNumber,
          Coordinate location}) =>
      Store(
          id: id,
          name: name,
          description: description,
          registerers: registerers,
          registeredNumber: registeredNumber,
          location: location);

  static Store fromJson(dynamic json) => Store(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      registerers: json['registerer'],
      registeredNumber: json['registered_number'],
      location: json['location']);

  static Coordinate getStoreCoordinate(String location) {
    final rawCoordinate = location
        .substring(location.indexOf('(') + 1, location.indexOf(')'))
        .split(' ');

    return Coordinate(
      lat: double.parse(rawCoordinate[0]),
      lng: double.parse(rawCoordinate[1]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}

class Stock extends Equatable {
  final Store store;
  final Product product;
  final int price;
  final int amount;

  const Stock({this.store, this.product, this.price, this.amount});

  @override
  List<Object> get props => [store, product, price, amount];

  @override
  String toString() =>
      'Stock{store: $store, product: $product, price: $price, amount: $amount}';

  Stock copyWith({Store store, Product product, int price, int amount}) =>
      Stock(
        store: store,
        product: product,
        price: price,
        amount: amount,
      );

  static Stock fromJson(dynamic json) => Stock(
        store: Store.fromJson(json['store']),
        product: Product.fromJson(json['product']),
        price: json['price'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'store': store,
        'product': product,
        'price': price,
        'amount': amount,
      };
}
