import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Eliverd/bloc/events/searchEvent.dart';
import 'package:Eliverd/bloc/states/searchState.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final StoreRepository storeRepository;

  SearchBloc({@required this.storeRepository}) : assert(storeRepository != null), super(NotSearched());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchNearbyItems) {
      yield* _mapSearchNearbyItemsToState(event);
    }
  }

  Stream<SearchState> _mapSearchNearbyItemsToState(SearchNearbyItems event) async* {
    try {
      final items = await storeRepository.fetchSearchedItems(event.coordinate, event.name);

      yield NearbyItemsSearched(items);
    } catch (_) {
      yield SearchError();
    }
  }
}
