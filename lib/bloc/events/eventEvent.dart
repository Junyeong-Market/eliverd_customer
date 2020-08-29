import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class FetchEventItem extends EventEvent {
  final Coordinate currentLocation;

  const FetchEventItem(this.currentLocation);

  @override
  List<Object> get props => [currentLocation];

  @override
  String toString() {
    return 'FetchEventItem{ currentLocation: $currentLocation }';
  }
}
