import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Eliverd/bloc/events/storeEvent.dart';
import 'package:Eliverd/bloc/states/storeState.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository storeRepository;

  StoreBloc({@required this.storeRepository}) : assert(storeRepository != null), super(StoreNotFetched());

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is FetchStore) {
      yield* _mapFetchStoreToState(event);
    }
  }

  Stream<StoreState> _mapFetchStoreToState(StoreEvent event) async* {
    try {
      yield StoreNotFetched();

      final stores =
          await storeRepository.fetchStores((event as FetchStore).coordinate);

      final stockList = await Future.wait(stores.map((store) async => await storeRepository.fetchStocks(store)));

      final stocks = stockList.fold(<Stock>[], (previous, stocks) => previous + stocks);

      yield StoreFetched(stocks);
    } catch (_) {
      yield StoreError();
    }
  }
}
