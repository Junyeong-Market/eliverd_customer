import 'package:Eliverd/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class NotSearched extends SearchState {}

class NearbyItemsSearched extends SearchState {
  final List<Stock> items;

  const NearbyItemsSearched(this.items);

  @override
  List<Object> get props => [items];
}

class SearchError extends SearchState {}

