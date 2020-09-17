import 'package:equatable/equatable.dart';

import 'package:Eliverd/models/models.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageNotUploaded extends ImageState {}

class ImageUploaded extends ImageState {
  final Asset image;

  const ImageUploaded(this.image);

  @override
  List<Object> get props => [image];
}

class ImageError extends ImageState {}