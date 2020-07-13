import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

class StoreNotFetched extends StoreState {}

class StoreFetched extends StoreState {
  final List<Stock> stocks;

  const StoreFetched(this.stocks);

  @override
  List<Object> get props => [stocks];
}

class StoreSelected extends StoreState {
  final Store store;

  const StoreSelected(this.store);

  @override
  List<Object> get props => [store];
}

class StoreError extends StoreState {}