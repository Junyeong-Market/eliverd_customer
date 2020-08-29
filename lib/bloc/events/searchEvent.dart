import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:Eliverd/models/models.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchNearbyItems extends SearchEvent {
  final Coordinate coordinate;
  final String name;
  final String category;

  const SearchNearbyItems({@required this.coordinate, @required this.name, this.category});

  @override
  List<Object> get props => [coordinate, name, category];

  @override
  String toString() {
    return 'SearchNearbyItems{ coordinate: $coordinate, name: $name, category: $category }';
  }
}
