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

  const SearchNearbyItems({@required this.coordinate, @required this.name});

  @override
  List<Object> get props => [coordinate, name];

  @override
  String toString() {
    return 'SearchNearbyItems{ coordinate: $coordinate, name: $name }';
  }
}
