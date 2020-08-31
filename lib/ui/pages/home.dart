import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:Eliverd/bloc/events/storeEvent.dart';
import 'package:Eliverd/bloc/states/storeState.dart';
import 'package:Eliverd/bloc/storeBloc.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/common/string.dart';
import 'package:Eliverd/common/marker.dart';

import 'package:Eliverd/ui/pages/store_display.dart';
import 'package:Eliverd/ui/pages/eliverd_info.dart';
import 'package:Eliverd/ui/pages/my_page.dart';
import 'package:Eliverd/ui/pages/order_lookup.dart';
import 'package:Eliverd/ui/widgets/shopping_cart_button.dart';
import 'package:Eliverd/ui/pages/search_items.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Coordinate> _coordinate;
  Future<Set<Marker>> _storeMarkers;

  Completer<GoogleMapController> googleMapController = Completer();
  CameraPosition _cameraPosition;

  Timer timer;

  @override
  void initState() {
    super.initState();

    _coordinate = _getCurrentLocation();

    _coordinate.then((coordinate) {
      setState(() {
        _cameraPosition = _cameraPosition ??
            CameraPosition(
              target: LatLng(coordinate.lat, coordinate.lng),
              zoom: 16.0,
            );
      });

      context.bloc<StoreBloc>().add(FetchStore(coordinate));
    });

    timer = Timer.periodic(
      Duration(
        seconds: 30,
      ),
      (Timer t) {
        final currentCoordinate = Coordinate(
          lat: _cameraPosition.target.latitude,
          lng: _cameraPosition.target.longitude,
        );

        context.bloc<StoreBloc>().add(FetchStore(currentCoordinate));
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: _buildMap(),
            ),
            Positioned(
              top: kToolbarHeight,
              left: width * 0.05,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => SearchItems(),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );
                    },
                    child: _buildSearchBox(width),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: height * 0.05,
              left: width * 0.05,
              child: _buildBottomNavigationBar(width),
            ),
          ],
        ),
      ),
    );
  }

  final _gesterRecognizer = <Factory<OneSequenceGestureRecognizer>>[
    Factory<OneSequenceGestureRecognizer>(
      () => EagerGestureRecognizer(),
    ),
  ].toSet();

  Future<Coordinate> _getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

    return Coordinate(
      lat: position.latitude,
      lng: position.longitude,
    );
  }

  Future<Set<Marker>> _getStoreMarkers(List<Stock> stocks) async {
    final stockBatch = groupBy(stocks, (stock) => stock.store);
    final stores = stockBatch.keys;

    final markers = await Future.wait(stores.map((store) async {
      final icon = await Markers.getMarkerIcon(store.name);

      return Marker(
        markerId: MarkerId(store.id.toString()),
        position: LatLng(store.location.lat, store.location.lng),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreDisplay(
                stocks: stockBatch[store],
              ),
            ),
          );
        },
        icon: icon,
      );
    })).then((value) => value.toSet());

    return markers;
  }

  Widget _buildMap() => Container(
        width: double.infinity,
        height: double.infinity,
        child: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state is StoreError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minWidth: 0,
                      height: 0,
                      child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        textColor: Colors.black12,
                        child: Text(
                          '⟳',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 48.0,
                          ),
                        ),
                        onPressed: () {
                          _coordinate.then((coordinate) {
                            context
                                .bloc<StoreBloc>()
                                .add(FetchStore(coordinate));
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                    ),
                    Text(
                      '지도를 불러오는 중 오류가 발생했습니다.\n다시 시도해주세요.',
                      style: TextStyle(
                        color: Colors.black26,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is StoreFetched) {
              _storeMarkers = _getStoreMarkers(state.stocks);

              return FutureBuilder<Set<Marker>>(
                future: _storeMarkers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _cameraPosition,
                      zoomGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        googleMapController.complete(controller);
                      },
                      onCameraMove: (CameraPosition cameraPosition) {
                        _cameraPosition = cameraPosition;
                      },
                      gestureRecognizers: _gesterRecognizer,
                      markers: snapshot.data ?? Set.of([]),
                    );
                  }

                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                },
              );
            }

            return Center(
              child: CupertinoActivityIndicator(),
            );
          },
        ),
      );

  Widget _buildSearchBox(double width) => Container(
        width: width * 0.9,
        height: 48.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '􀊫',
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 24.0,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Text(
                HomePageStrings.searchProductHelperText,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              ),
            ),
            ShoppingCartButton(),
          ],
        ),
      );

  Widget _buildBottomNavigationBar(double width) => Container(
        width: width * 0.9,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPagePage(),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '􀉩',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '마이페이지',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderLookupPage(),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '􀈫',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '주문 내역',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EliverdInfoPage(),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '􀅴',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '오늘의 혜택',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
