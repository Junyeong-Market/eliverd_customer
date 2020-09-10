import 'package:Eliverd/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class DeliveryEvent extends Equatable {
  const DeliveryEvent();

  @override
  List<Object> get props => [];
}

class FetchDeliveries extends DeliveryEvent {}

class StartDelivery extends DeliveryEvent {
  final PartialOrder delivery;

  const StartDelivery(this.delivery);

  @override
  List<Object> get props => [delivery];

  @override
  String toString() {
    return 'StartDelivery{ delivery: $delivery }';
  }
}

class FinishDelivery extends DeliveryEvent {
  final PartialOrder delivery;

  const FinishDelivery(this.delivery);

  @override
  List<Object> get props => [delivery];

  @override
  String toString() {
    return 'FinishDelivery{ delivery: $delivery }';
  }
}