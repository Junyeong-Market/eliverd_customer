import 'package:Eliverd/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventItemFetched extends EventState {
  final List<Stock> items;

  const EventItemFetched(this.items);

  @override
  List<Object> get props => [items];
}

class EventError extends EventState {}
