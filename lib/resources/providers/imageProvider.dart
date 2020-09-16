import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageAPIClient {
  static const baseUrl = 'SECRET:8000';
  final http.Client httpClient;

  ImageAPIClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<String> fetchImage(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/assets/$id/';
    final res = await httpClient.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: session,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error occurred while fetching image');
    }

    final decoded = utf8.decode(res.bodyBytes);

    return json.decode(decoded)['image'] as String;
  }

  Future<String> uploadImage(
      String imageName, String imageExt, Uint8List imageBytes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final session = prefs.getString('session');

    final url = '$baseUrl/assets/';

    final res = await httpClient.post(
      url,
      headers: <String, String>{
        'Authorization': session,
        'Content-Type': 'image/$imageExt',
        'Content-Disposition': 'inline;filename=$imageName',
      },
      body: imageBytes,
    );

    if (res.statusCode != 201) {
      throw Exception('Error occurred while uploading a image');
    }

    final decoded = utf8.decode(res.bodyBytes);

    return json.decode(decoded)['image'] as String;
  }
}
