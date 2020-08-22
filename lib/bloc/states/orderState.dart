import 'package:Eliverd/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderInProgress extends OrderState {
  final String redirectURL;

  const OrderInProgress(this.redirectURL);

  @override
  List<Object> get props => [redirectURL];
}

class OrderApproved extends OrderState {
  final Order order;

  const OrderApproved(this.order);

  @override
  List<Object> get props => [order];
}

class OrderCanceled extends OrderState {
  final Order order;

  const OrderCanceled(this.order);

  @override
  List<Object> get props => [order];
}

class OrderFailed extends OrderState {
  final Order order;

  const OrderFailed(this.order);

  @override
  List<Object> get props => [order];
}

class OrderDone extends OrderState {}

class OrderError extends OrderState {}

