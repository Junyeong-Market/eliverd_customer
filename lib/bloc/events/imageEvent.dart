import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class UploadImage extends ImageEvent {
  final File image;

  const UploadImage(this.image);

  @override
  List<Object> get props => [image];

  @override
  String toString() {
    return 'UploadImage{ image: $image }';
  }
}