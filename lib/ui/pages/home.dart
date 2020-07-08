import 'dart:async';

import 'package:Eliverd/common/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Future<CameraPosition> _getResponses;
  Marker _selectedMarker;

  static const double minExtent = 0.08;
  static const double maxExtent = 1.0;

  bool isExpanded = false;
  double initialExtent = minExtent;
  BuildContext draggableSheetContext;

  @override
  void initState() {
    super.initState();

    _getResponses = _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: FutureBuilder<CameraPosition>(
                future: _getResponses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: snapshot.data,
                        zoomGesturesEnabled: true,
                        tiltGesturesEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        gestureRecognizers: _gesterRecognizer,
                        onTap: _onMapTapped,
                        markers: _selectedMarker != null
                            ? Set.of([_selectedMarker])
                            : Set.of([]),
                      );
                    } else {
                      return RefreshIndicator(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ButtonTheme(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              minWidth: 0,
                              height: 0,
                              child: FlatButton(
                                padding: EdgeInsets.all(0.0),
                                textColor: Colors.black12,
                                child: Text(
                                  '⟳',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 56.0,
                                  ),
                                ),
                                onPressed: () {
                                  return _getCurrentLocation();
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            ),
                            Text(
                              '오류가 났엉... 다시다시',
                              style: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onRefresh: () {
                          return _getCurrentLocation();
                        },
                      );
                    }
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '불러오고 있음-_- 좀 기다려봐',
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
            ),
          ),
          Positioned(
            top: 60.0,
            left: 20.0,
            child: Container(
              width: width * 0.9,
              height: height * 0.05,
              child: CupertinoTextField(
                placeholder: HomePageStrings.searchProductHelperText,
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: Container(
              width: width * 0.9,
              height: height * 0.05,
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: width,
              height: height * 0.8,
              child: SizedBox.expand(
                child: InkWell(
                  onTap: _toggleDraggableScrollableSheet,
                  child: DraggableScrollableActuator(
                    child: DraggableScrollableSheet(
                      key: Key(initialExtent.toString()),
                      minChildSize: minExtent,
                      maxChildSize: maxExtent,
                      initialChildSize: initialExtent,
                      builder: _draggableScrollableSheetBuilder,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final _gesterRecognizer = <Factory<OneSequenceGestureRecognizer>>[
    Factory<OneSequenceGestureRecognizer>(
      () => EagerGestureRecognizer(),
    ),
  ].toSet();

  void _toggleDraggableScrollableSheet() {
    if (draggableSheetContext != null) {
      setState(() {
        initialExtent = isExpanded ? minExtent : maxExtent;
        isExpanded = !isExpanded;
      });
      DraggableScrollableActuator.reset(draggableSheetContext);
    }
  }

  void _onMapTapped(LatLng position) async {
    String address = await _getAddressFromPosition(position);

    setState(() {
      _selectedMarker = _selectedMarker.copyWith(
        positionParam: position,
        infoWindowParam: _selectedMarker.infoWindow.copyWith(
          snippetParam: address,
        ),
      );
    });
  }

  Widget _draggableScrollableSheetBuilder(
    BuildContext context,
    ScrollController scrollController,
  ) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    draggableSheetContext = context;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: height * 0.05,
      ),
      child: ListView(
        children: <Widget>[
          Divider(
            indent: 120.0,
            endIndent: 120.0,
            height: 16.0,
            thickness: 4.0,
          ),
          Container(
            width: width,
            height: height * 0.7,
            child: ListView.builder(
              controller: scrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<CameraPosition> _getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    LatLng latlng = LatLng(position.latitude, position.longitude);
    String address = await _getAddressFromPosition(latlng);

    setState(() {
      _selectedMarker = Marker(
          markerId: MarkerId('Selected'),
          position: latlng,
          infoWindow: InfoWindow(title: '위치', snippet: address),
          draggable: true,
          onDragEnd: (position) {
            _selectedMarker = _selectedMarker.copyWith(
              positionParam: position,
            );
          });
    });

    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 20.0,
    );
  }

  Future<String> _getAddressFromPosition(LatLng position) async {
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: 'ko_KR',
    );

    return placemarks
        .map((placemark) =>
            '${placemark.country} ${placemark.administrativeArea} ${placemark.locality} ${placemark.name} ${placemark.postalCode}')
        .join(',');
  }
}
