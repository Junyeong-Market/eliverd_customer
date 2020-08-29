import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

import 'package:Eliverd/bloc/events/eventEvent.dart';
import 'package:Eliverd/bloc/states/eventState.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final StoreRepository storeRepository;

  EventBloc(
      {@required this.storeRepository})
      : assert(PurchaseRepository != null),
        super(EventInitial());

  @override
  Stream<EventState> mapEventToState(EventEvent event) async* {
    if (event is FetchEventItem) {
      yield* _mapFetchEventItemToState(event);
    }
  }

  Stream<EventState> _mapFetchEventItemToState(FetchEventItem event) async* {
    try {
      final items = await storeRepository.fetchEventItems(event.currentLocation);

      print(items);
      yield EventItemFetched(items);
    } catch (_) {
      yield EventError();
    }
  }
}
