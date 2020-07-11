import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:Eliverd/bloc/authBloc.dart';
import 'package:Eliverd/bloc/states/authState.dart';

import 'package:Eliverd/common/string.dart';
import 'package:Eliverd/common/color.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Future<CameraPosition> _getResponses;
  Marker _selectedMarker;

  bool _isSearching = false;
  bool _isInfoSheetExpandedToMaximum = false;

  // bool _isCartRequested = false;

  static const double minExtent = 0.06;
  static const double maxExtentOnKeyboardVisible = 0.48;
  static const double maxExtent = 0.88;

  double initialExtent = 0.4;
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
                              HomePageStrings.googleMapCannotBeLoaded,
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
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height * 0.18,
              color: _shouldSheetExpanded() ? Colors.white : Colors.transparent,
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: width,
              height: height,
              child: SizedBox.expand(
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    setState(() {
                      if (notification.extent == maxExtent) {
                        _isInfoSheetExpandedToMaximum = true;
                      } else {
                        _isInfoSheetExpandedToMaximum = false;
                      }
                    });

                    return false;
                  },
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
          Positioned(
            top: 32.0,
            left: width * 0.05,
            child: Container(
              width: width * 0.9,
              height: 48.0,
              decoration: BoxDecoration(
                color: _shouldSheetExpanded()
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                border: Border.all(
                  color: Colors.black26,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              padding: EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildUserProfileButton(),
                  Flexible(
                    fit: FlexFit.loose,
                    child: CupertinoTextField(
                      placeholder: HomePageStrings.searchProductHelperText,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      onTap: () {
                        _changeDraggableScrollableSheet(
                            maxExtentOnKeyboardVisible);

                        setState(() {
                          _isSearching = true;
                        });
                      },
                      onSubmitted: (value) {
                        _changeDraggableScrollableSheet(minExtent);

                        setState(() {
                          _isSearching = false;
                        });
                      },
                    ),
                  ),
                  _buildCartButton(),
                ],
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

  bool _shouldSheetExpanded() => _isSearching || _isInfoSheetExpandedToMaximum;

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
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: height * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: height / 80.0),
          Divider(
            indent: 120.0,
            endIndent: 120.0,
            height: 16.0,
            thickness: 4.0,
          ),
          SizedBox(height: height / 80.0),
          Expanded(
            flex: 1,
            child: ListView(
              physics: _isSearching
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              controller: scrollController,
              children: <Widget>[
                _buildHomeSheetByState(width, height),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeDraggableScrollableSheet(double extent) {
    if (draggableSheetContext != null) {
      setState(() {
        initialExtent = extent;

        if (extent == maxExtent) {
          _isInfoSheetExpandedToMaximum = true;
        } else {
          _isInfoSheetExpandedToMaximum = false;
        }
      });

      DraggableScrollableActuator.reset(draggableSheetContext);
    }
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

  Widget _buildCartButton() => ButtonTheme(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        height: 0,
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          textColor: Colors.black38,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Text(
            '􀍩',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24.0,
            ),
          ),
          onPressed: () {},
        ),
      );

  Widget _buildUserProfileButton() => BlocBuilder<AuthenticationBloc, AuthenticationState>(
    builder: (context, state) {
      if (state is Authenticated) {
        return Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black38, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          child: Center(
            child: Text(
              state.user.nickname,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontSize: 11.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }

      return Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black38, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        child: Center(
          child: Text(
            '오류',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 11.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    },
  );

  Widget _buildHomeSheetByState(double width, double height) => _isSearching
      ? _buildSearchResult(width, height)
      : _buildInfoSheet(width, height);

  Widget _buildSearchResult(double width, double height) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: height / 80.0),
          Text('언제나 난 검색 중!'),
        ],
      );

  Widget _buildInfoSheet(double width, double height) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: width,
            height: height * 0.3,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [eliverdLightColor, eliverdDarkColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Text(
              '누가 봐도 오늘의 대표 상품 소개하는 배너',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 28.0,
              ),
            ),
          ),
          SizedBox(height: height / 40.0),
          Text(
            '카테고리 살펴보기',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 28.0,
            ),
          ),
          SizedBox(height: height / 80.0),
          Container(
            width: width,
            height: height * 0.2,
            child: GridView(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8.0,
              ),
              children: <Widget>[
                Container(
                  width: width,
                  height: height * 0.2,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Text(
                    '음식',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: height * 0.2,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Text(
                    '생활용품',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: height * 0.2,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Text(
                    '음반',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: height * 0.2,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Text(
                    '의류',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: height * 0.2,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Text(
                    '식물',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height / 40.0),
          Text(
            '내가 가장 많이 살펴본 물건은?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 28.0,
            ),
          ),
          SizedBox(height: height / 80.0),
          Container(
            width: width,
            height: height * 0.25,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'ㅇㅇㅇ 님은...',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 26.0,
                  ),
                ),
                Text(
                  'ㅇㅇ을 가장 좋아하시네요!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height / 40.0),
        ],
      );
}
