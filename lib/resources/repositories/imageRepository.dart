import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';

import 'package:Eliverd/resources/providers/providers.dart';

class ImageRepository {
  final ImageAPIClient imageAPIClient;

  ImageRepository({@required this.imageAPIClient})
      : assert(imageAPIClient != null);

  Future<String> uploadImage(File image) async {
    if (!image.existsSync()) {
      throw Exception('File doesn\'t exist!');
    }

    final url = await imageAPIClient.uploadImage(basename(image.path), image.readAsBytesSync());

    return url;
  }
}