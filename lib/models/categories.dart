import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Categories {
  // ignore: non_constant_identifier_names
  static final FASHION = Category(
    id: 'fashion',
    icon: '􀖆',
    color: Colors.purpleAccent,
    text: '의류',
  );

  // ignore: non_constant_identifier_names
  static final BEAUTY = Category(
    id: 'beauty',
    icon: '􀜍',
    color: Colors.pinkAccent,
    text: '화장품',
  );

  // ignore: non_constant_identifier_names
  static final BABY = Category(
    id: 'baby',
    icon: '􀎸',
    color: Colors.amber,
    text: '육아용품',
  );

  // ignore: non_constant_identifier_names
  static final FOOD = Category(
    id: 'food',
    icon: '􀊴',
    color: Colors.deepOrange,
    text: '식료품',
  );

  // ignore: non_constant_identifier_names
  static final KITCHEN = Category(
    id: 'kitchen',
    icon: '􀍺',
    color: Colors.blueGrey,
    text: '주방용품',
  );

  // ignore: non_constant_identifier_names
  static final LIVING = Category(
    id: 'living',
    icon: '􀙩',
    color: Colors.lightGreen,
    text: '생활용품',
  );

  // ignore: non_constant_identifier_names
  static final FURNITURE = Category(
    id: 'furniture',
    icon: '􀎲',
    color: Colors.green,
    text: '가구',
  );

  // ignore: non_constant_identifier_names
  static final DIGITAL = Category(
    id: 'digital',
    icon: '􀙗',
    color: Colors.indigoAccent,
    text: '전자제품',
  );

  // ignore: non_constant_identifier_names
  static final LEISURE = Category(
    id: 'leisure',
    icon: '􀝐',
    color: Colors.greenAccent,
    text: '스포츠/레저',
  );

  // ignore: non_constant_identifier_names
  static final CAR = Category(
    id: 'car',
    icon: '􀙘',
    color: Colors.redAccent,
    text: '자동차용품',
  );

  // ignore: non_constant_identifier_names
  static final PUBLICATION = Category(
    id: 'publication',
    icon: '􀉚',
    color: Colors.indigo,
    text: '도서/영화/음반',
  );

  // ignore: non_constant_identifier_names
  static final TOY = Category(
    id: 'toy',
    icon: '􀛸',
    color: Colors.orangeAccent,
    text: '장난감',
  );

  // ignore: non_constant_identifier_names
  static final OFFICE = Category(
    id: 'office',
    icon: '􀒋',
    color: Colors.amberAccent,
    text: '문구류',
  );

  // ignore: non_constant_identifier_names
  static final PET = Category(
    id: 'pet',
    icon: '􀓎',
    color: Colors.brown,
    text: '동물용품',
  );

  // ignore: non_constant_identifier_names
  static final HEALTH = Category(
    id: 'health',
    icon: '􀑆',
    color: Colors.red,
    text: '헬스용품',
  );

  static final listByViewPOV = [
    FASHION,
    BEAUTY,
    BABY,
    FOOD,
    KITCHEN,
    LIVING,
    FURNITURE,
    DIGITAL,
    LEISURE,
    CAR,
    PUBLICATION,
    TOY,
    OFFICE,
    PET,
    HEALTH
  ];

  static get listByNetworkPOV => Map.fromIterable(listByViewPOV,
      key: (category) => category.id, value: (category) => category);
}

class Category extends Equatable {
  final String id;
  final String icon;
  final Color color;
  final String text;

  Category(
      {@required this.id,
      @required this.icon,
      @required this.color,
      @required this.text});

  @override
  List<Object> get props => [id, icon, color, text];

  @override
  String toString() {
    return 'Category{ categoryId: $id, icon: $icon, color: $color, text: $text }';
  }
}
