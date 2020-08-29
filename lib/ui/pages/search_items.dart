import 'package:Eliverd/bloc/events/searchEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:Eliverd/bloc/searchBloc.dart';
import 'package:Eliverd/bloc/states/searchState.dart';

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/resources/repositories/repositories.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/widgets/stock.dart';

class SearchItems extends StatefulWidget {
  @override
  _SearchItemsState createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  SearchBloc _searchBloc;
  Future<Coordinate> _currentLocation;

  @override
  void initState() {
    super.initState();

    _searchBloc = SearchBloc(
      storeRepository: StoreRepository(
        storeAPIClient: StoreAPIClient(
          httpClient: http.Client(),
        ),
      ),
    );

    _currentLocation = _getCurrentLocation();

    _currentLocation.then((location) {
      _searchBloc.add(SearchNearbyItems(
        coordinate: location,
        name: '',
      ));
    });
  }

  @override
  void dispose() {
    _searchBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocConsumer<SearchBloc, SearchState>(
      cubit: _searchBloc,
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: ListView(
            padding: EdgeInsets.only(
              top: kToolbarHeight,
              bottom: 24.0,
              left: 16.0,
              right: 16.0,
            ),
            children: [
              Container(
                width: width * 0.9,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ButtonTheme(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minWidth: 0,
                      height: 0,
                      child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        textColor: Colors.black,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text(
                          '􀄪',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 24.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        autofocus: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () {},
                        onChanged: (value) {
                          _currentLocation.then((location) {
                            _searchBloc.add(SearchNearbyItems(
                              coordinate: location,
                              name: value,
                            ));
                          });
                        },
                      ),
                    ),
                    ButtonTheme(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minWidth: 0,
                      height: 0,
                      child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        textColor: Colors.black,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text(
                          '􀌆',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 24.0,
                          ),
                        ),
                        onPressed: () {
                          // TO-DO: 검색 조건 설정
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              if (state is NearbyItemsSearched)
                state.items.isEmpty
                    ? Center(
                        child: Text(
                          '상품이 검색되지 않습니다. 다른 키워드로 검색해보세요!',
                          style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        width: width,
                        height: height,
                        child: GridView.builder(
                          padding: EdgeInsets.all(0.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            childAspectRatio: 0.52,
                          ),
                          itemBuilder: (context, index) => SimplifiedStock(
                            stock: state.items[index],
                          ),
                          itemCount: state.items.length,
                        ),
                      ),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Future<Coordinate> _getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

    return Coordinate(
      lat: position.latitude,
      lng: position.longitude,
    );
  }
}
