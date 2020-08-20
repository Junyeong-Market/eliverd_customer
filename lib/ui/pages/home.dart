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
import 'package:Eliverd/ui/widgets/category.dart';
import 'package:Eliverd/ui/widgets/shopping_cart_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Future<Coordinate> _coordinate;
  Future<Set<Marker>> _storeMarkers;

  @override
  void initState() {
    super.initState();

    _coordinate = _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
              top: 80.0,
              left: width * 0.05,
              child: Container(
                width: width * 0.9,
                height: 24.0,
                padding: EdgeInsets.symmetric(
                  vertical: 1.0,
                ),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.2,
                  ),
                  itemBuilder: (context, index) {
                    return CategoryWidget(
                      categoryId: Categories.listByViewPOV[index].id,
                    );
                  },
                  itemCount: Categories.listByViewPOV.length,
                ),
              ),
            ),
            Positioned(
              top: 32.0,
              left: width * 0.05,
              child: _buildSearchBox(width),
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
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

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
        child: FutureBuilder<Coordinate>(
          future: _coordinate,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final coordinate = snapshot.data;

              final cameraPosition = CameraPosition(
                target: LatLng(coordinate.lat, coordinate.lng),
                zoom: 20.0,
              );

              context.bloc<StoreBloc>().add(FetchStore(coordinate));

              return BlocConsumer<StoreBloc, StoreState>(
                  listener: (context, state) {
                if (state is StoreFetched) {
                  _storeMarkers = _getStoreMarkers(state.stocks);
                }
              }, builder: (context, state) {
                return FutureBuilder<Set<Marker>>(
                  future: _storeMarkers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: cameraPosition,
                        zoomGesturesEnabled: true,
                        tiltGesturesEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        gestureRecognizers: _gesterRecognizer,
                        markers: snapshot.data ?? Set.of([]),
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            HomePageStrings.googleMapLoading,
                            style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          CupertinoActivityIndicator(),
                        ],
                      ),
                    );
                  },
                );
              });
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    HomePageStrings.googleMapLoading,
                    style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  CupertinoActivityIndicator(),
                ],
              ),
            );
          },
        ),
      );

  Widget _buildSearchBox(double width) => Container(
        width: width * 0.9,
        height: 40.0,
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
        padding: EdgeInsets.all(4.0),
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
            Flexible(
              fit: FlexFit.loose,
              child: CupertinoTextField(
                placeholder: HomePageStrings.searchProductHelperText,
                placeholderStyle: TextStyle(
                  color: Colors.black87,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                onTap: () {},
                onChanged: (value) {
                  // TO-DO: 상품 검색 BLOC 이벤트 요청하기
                },
                onSubmitted: (value) {},
              ),
            ),
            ShoppingCartButton(),
          ],
        ),
      );
}
