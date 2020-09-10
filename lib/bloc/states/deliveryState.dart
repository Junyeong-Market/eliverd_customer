import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:Eliverd/models/models.dart';

abstract class DeliveryState extends Equatable {
  const DeliveryState();

  @override
  List<Object> get props => [];
}

class DeliveryInitial extends DeliveryState {}

class DeliveryFetched extends DeliveryState {
  final List<PartialOrder> deliveries;
  final bool isAllFetched;
  final int page;

  const DeliveryFetched({@required this.deliveries, @required this.isAllFetched, this.page = 1});
  @override
  List<Object> get props => [deliveries, isAllFetched, page];

  @override
  String toString() {
    return 'DeliveryFetched{ deliveries: $deliveries, isAllFetched: $isAllFetched, page: $page }';
  }
}

class DeliveryError extends DeliveryState {}