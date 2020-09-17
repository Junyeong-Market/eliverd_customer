import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final int id;
  final String image;

  Asset({this.id, this.image});

  @override
  List<Object> get props => [id, image];

  static Asset fromJson(dynamic json) => Asset(
        id: json['id'],
        image: json['image'],
      );

  @override
  String toString() {
    return 'Asset{ id: $id, image: $image }';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
      };
}
