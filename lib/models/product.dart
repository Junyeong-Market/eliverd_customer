import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final Manufacturer manufacturer;
  final String ian;
  final String category;

  Product({this.id, this.name, this.manufacturer, this.ian, this.category});

  @override
  List<Object> get props => [id, name, manufacturer, ian, category];

  @override
  String toString() =>
      'Product { id: $id, name: $name, manufacturer: $manufacturer, ian: $ian, category: $category }';

  Product copyWith(
          {int id, String name, Manufacturer manufacturer, String ian, String category}) =>
      Product(
        id: id,
        name: name,
        manufacturer: manufacturer,
        ian: ian,
        category: category,
      );

  static Product fromJson(dynamic json) => Product(
        id: json['id'],
        name: json['name'],
        manufacturer: Manufacturer.fromJson(json['manufacturer']),
        ian: json['ian'],
        category: json['category'],
      );
}

class Manufacturer extends Equatable {
  final int id;
  final String name;

  Manufacturer({this.id, this.name});

  @override
  List<Object> get props => [id, name];

  @override
  String toString() => 'Manufacturer { id: $id, name: $name }';

  Manufacturer copyWith({int id, String name}) => Manufacturer(
        id: id,
        name: name,
      );

  static Manufacturer fromJson(dynamic json) => Manufacturer(
        id: json['id'],
        name: json['name'],
      );
}
