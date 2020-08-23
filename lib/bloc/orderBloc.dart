import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

import 'package:Eliverd/bloc/events/orderEvent.dart';
import 'package:Eliverd/bloc/states/orderState.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PurchaseRepository purchaseRepository;

  OrderBloc({@required this.purchaseRepository})
      : assert(PurchaseRepository != null), super(OrderInitial());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is ProceedOrder) {
      yield* _mapProceedOrderToState(event);
    } else if (event is ApproveOrder) {
      yield* _mapApproveOrderToState(event);
    } else if (event is CancelOrder) {
      yield* _mapCancelOrderToState(event);
    } else if (event is FailOrder) {
      yield* _mapFailOrderToState(event);
    }
  }

  Stream<OrderState> _mapProceedOrderToState(ProceedOrder event) async* {
    try {
      final redirectURL = await purchaseRepository.getCheckoutByCart(event.items, event.amounts, event.isDelivery);

      yield OrderInProgress(redirectURL);
    } catch (_) {
      yield OrderError();
    }
  }

  Stream<OrderState> _mapApproveOrderToState(ApproveOrder event) async* {
    try {
      final order = await purchaseRepository.approveOrder(event.url);

      yield OrderApproved(order);
    } catch (_) {
      yield OrderError();
    }
  }

  Stream<OrderState> _mapCancelOrderToState(CancelOrder event) async* {
    try {
      final order = await purchaseRepository.cancelOrder(event.url);

      yield OrderCanceled(order);
    } catch (_) {
      yield OrderError();
    }
  }

  Stream<OrderState> _mapFailOrderToState(FailOrder event) async* {
    try {
      final order = await purchaseRepository.failOrder(event.url);

      yield OrderFailed(order);
    } catch (_) {
      yield OrderError();
    }
  }
}
