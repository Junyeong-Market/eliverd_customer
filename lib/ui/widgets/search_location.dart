import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/common/color.dart';

class SearchLocationDialog extends StatefulWidget {
  final ValueChanged<Coordinate> onLocationSelected;

  const SearchLocationDialog({Key key, this.onLocationSelected}) : super(key: key);

  @override
  _SearchLocationDialogState createState() => _SearchLocationDialogState();
}

class _SearchLocationDialogState extends State<SearchLocationDialog> {
  Completer<GoogleMapController> _controller = Completer();
  Future<CameraPosition> _getResponses;
  Marker _selectedMarker;

  @override
  void initState() {
    super.initState();

    _getResponses = _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.8,
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: height / 64.0),
          Divider(
            indent: 140.0,
            endIndent: 140.0,
            height: 16.0,
            thickness: 4.0,
          ),
          SizedBox(height: height / 64.0),
          Text(
            '배송 위치 등록',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 26.0,
            ),
          ),
          Text(
            '주문할 상품을 배송할 위치를 선택하세요.',
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: height / 48.0),
          FutureBuilder<CameraPosition>(
            future: _getResponses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: height * 0.6,
                        child: GoogleMap(
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
                        ),
                      ),
                    ],
                  );
                } else {
                  return RefreshIndicator(
                    child: Center(
                      child: Column(
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
                            '오류',
                            style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
                    CupertinoActivityIndicator(),
                    SizedBox(height: 8.0),
                    Text(
                      '지도 로드 중',
                      style: TextStyle(
                        color: Colors.black26,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
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

  _onMapTapped(LatLng position) async {
    String address = await _getAddressFromPosition(position);

    setState(() {
      _selectedMarker = _selectedMarker.copyWith(
        positionParam: position,
        infoWindowParam: _selectedMarker.infoWindow.copyWith(
          snippetParam: address,
        ),
      );
    });

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          '이대로 등록하시겠습니까?',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        content: Text(
          '배송지를 ${_selectedMarker.infoWindow.snippet}(으)로 설정했습니다.',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text(
              '취소',
              style: TextStyle(
                color: eliverdColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoButton(
            child: Text(
              '등록',
              style: TextStyle(
                color: eliverdColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              final coordinate = Coordinate(
                lat: _selectedMarker.position.latitude,
                lng: _selectedMarker.position.longitude,
              );

              widget.onLocationSelected(coordinate);
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
          infoWindow: InfoWindow(
              title: '배송 위치',
              snippet: address),
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
