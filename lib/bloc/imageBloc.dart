import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:Eliverd/bloc/events/imageEvent.dart';
import 'package:Eliverd/bloc/states/imageState.dart';

import 'package:Eliverd/resources/repositories/repositories.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository imageRepository;

  ImageBloc({@required this.imageRepository}) : assert(imageRepository != null), super(ImageNotUploaded());

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is UploadImage) {
      yield* _mapUploadImageToState(event);
    }
  }

  Stream<ImageState> _mapUploadImageToState(UploadImage event) async* {
    try {
      final uploaded = await imageRepository.uploadImage(event.image);

      yield ImageUploaded(uploaded);
    } catch (_) {
      yield ImageError();
    }
  }
}
