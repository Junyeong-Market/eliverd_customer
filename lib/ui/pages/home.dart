import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<CameraPosition>(
        future: _getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: snapshot.data,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error,
                ),
              );
            }

            return Center(
              child: CupertinoActivityIndicator(),
            );
          },
      ),
    );
  }

  Future<CameraPosition> _getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 20.0,
    );
  }
}
