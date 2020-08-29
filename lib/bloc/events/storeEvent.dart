import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class FetchStore extends StoreEvent {
  final Coordinate coordinate;

  const FetchStore(this.coordinate);

  @override
  List<Object> get props => [coordinate];
}
