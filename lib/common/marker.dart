import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Markers {
  static final int categoryLength = 150;

  static Future<BitmapDescriptor> getMarkerIconByCategories(String storeName,
      List categories) async {
    PictureRecorder recorder = PictureRecorder();

    Canvas canvas = Canvas(recorder);

    final markerWidth = categoryLength * categories.length;
    final markerHeight = categoryLength;

    for (int i = 0; i < categories.length; i++) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SFProText',
          ),
          text: categories[i].icon,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final width = categoryLength + (i * categoryLength / 2);
      final height = categoryLength;
      final center = Offset(width / 2, height / 2);
      final radius = categoryLength / 8;

      Paint paintCircle = Paint()..color = categories[i].color;

      canvas.drawCircle(center, radius, paintCircle);
      textPainter.paint(canvas, Offset(width / 2.35, height / 2.35));
    }

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProText',
        ),
        text: storeName,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(0, 0));

    Picture picture = recorder.endRecording();

    ByteData pngBytes =
    await (await picture.toImage(markerWidth, markerHeight))
        .toByteData(format: ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes.buffer);

    return BitmapDescriptor.fromBytes(data);
  }
}
