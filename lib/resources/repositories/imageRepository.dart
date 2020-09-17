import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';

import 'package:Eliverd/models/models.dart';
import 'package:Eliverd/resources/providers/providers.dart';

class ImageRepository {
  final ImageAPIClient imageAPIClient;

  ImageRepository({@required this.imageAPIClient})
      : assert(imageAPIClient != null);

  Future<Asset> fetchImage(String id) async {
    final asset = await imageAPIClient.fetchImage(id);

    return asset;
  }

  Future<Asset> uploadImage(File image) async {
    if (!image.existsSync()) {
      throw Exception('File doesn\'t exist!');
    }

    final path = basename(image.path);
    final ext = extension(image.path).replaceAll('.', '');
    final bytes = image.readAsBytesSync();

    final asset = await imageAPIClient.uploadImage(path, ext, bytes);

    return asset;
  }
}
