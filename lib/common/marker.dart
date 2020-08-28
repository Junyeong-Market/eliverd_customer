import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Markers {
  static Future<BitmapDescriptor> getMarkerIcon(String storeName) async {
    TextPainter tp = TextPainter(
      text: TextSpan(
        text: storeName,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tp.text = TextSpan(
      text: storeName,
      style: TextStyle(
        fontSize: 35.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
        shadows: [
          Shadow(
            offset: Offset(-1.5, -1.5),
            color: Colors.white,
          ),
          Shadow(
            offset: Offset(1.5, -1.5),
            color: Colors.white,
          ),
          Shadow(
            offset: Offset(1.5, 1.5),
            color: Colors.white,
          ),
          Shadow(
            offset: Offset(-1.5, 1.5),
            color: Colors.white,
          ),
        ],
      ),
    );

    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    Rect oval = Rect.fromLTWH(
      0,
      0,
      75,
      75,
    );

    ui.Image image = await getBytesFromAsset('assets/images/shop.ico', 75);
    paintImage(
      canvas: canvas,
      image: image,
      rect: oval,
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );

    tp.layout();
    tp.paint(canvas, Offset(80.0, 40.0));

    Picture picture = recorder.endRecording();

    final ui.Image markerAsImage = await picture.toImage(
      300,
      80,
    );

    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  static Future<ui.Image> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);

    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List imageBytes =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))
            .buffer
            .asUint8List();

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }
}
