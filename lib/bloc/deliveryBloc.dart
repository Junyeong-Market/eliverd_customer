import 'package:Eliverd/models/order.dart';
import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

import 'package:Eliverd/bloc/events/deliveryEvent.dart';
import 'package:Eliverd/bloc/states/deliveryState.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final DeliveryRepository deliveryRepository;
  final AccountRepository accountRepository;

  DeliveryBloc(
      {@required this.deliveryRepository, @required this.accountRepository})
      : assert(deliveryRepository != null),
        assert(accountRepository != null),
        super(DeliveryInitial());

  @override
  Stream<DeliveryState> mapEventToState(DeliveryEvent event) async* {
    if (event is FetchDeliveries) {
      yield* _mapFetchDeliveriesToState(event);
    } else if (event is StartDelivery) {
      yield* _mapStartDeliveryToState(event);
    } else if (event is FinishDelivery) {
      yield* _mapFinishDeliveryToState(event);
    }
  }

  Stream<DeliveryState> _mapFetchDeliveriesToState(
      FetchDeliveries event) async* {
    final currentState = state;

    if (_isDeliveriesAllFetched(currentState)) {
      try {
        final user = await accountRepository.getUser();

        if (currentState is DeliveryFetched) {
          final deliveries = await accountRepository.fetchProcessingDeliveries(
              user.pid, currentState.page);

          yield deliveries.isEmpty || deliveries.length < 20
              ? DeliveryFetched(
                  deliveries: deliveries,
                  isAllFetched: true,
                  page: currentState.page,
                )
              : DeliveryFetched(
                  deliveries: deliveries,
                  isAllFetched: false,
                  page: currentState.page + 1,
                );
        } else {
          final deliveries =
              await accountRepository.fetchProcessingDeliveries(user.pid);

          yield deliveries.isEmpty || deliveries.length < 20
              ? DeliveryFetched(
                  deliveries: deliveries,
                  isAllFetched: true,
                )
              : DeliveryFetched(
                  deliveries: deliveries,
                  isAllFetched: false,
                  page: 2,
                );
        }
      } catch (_) {
        yield DeliveryError();
      }
    }
  }

  Stream<DeliveryState> _mapStartDeliveryToState(StartDelivery event) async* {
    try {
      final changed = await deliveryRepository
          .changeDeliveryState(event.delivery.transportToken);

      if (changed.status != DeliveryStatus.DELIVERING) {
        throw Exception('This order wasn\'t proceeded to deliver');
      }

      final user = await accountRepository.getUser();

      final deliveries =
          await accountRepository.fetchProcessingDeliveries(user.pid);

      yield DeliveryFetched(
        deliveries: deliveries,
        isAllFetched: false,
      );
    } catch (_) {
      yield DeliveryError();
    }
  }

  Stream<DeliveryState> _mapFinishDeliveryToState(FinishDelivery event) async* {
    try {
      final changed = await deliveryRepository
          .changeDeliveryState(event.delivery.transportToken);

      if (changed.status != DeliveryStatus.DELIVERED) {
        throw Exception('This delivery wasn\'t completed');
      }

      final user = await accountRepository.getUser();

      final deliveries =
          await accountRepository.fetchProcessingDeliveries(user.pid);

      yield DeliveryFetched(
        deliveries: deliveries,
        isAllFetched: false,
      );
    } catch (_) {
      yield DeliveryError();
    }
  }

  bool _isDeliveriesAllFetched(DeliveryState state) =>
      state is DeliveryFetched && state.isAllFetched;
}
