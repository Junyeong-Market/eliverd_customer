import 'package:Eliverd/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String categoryId;
  final double fontSize;
  final double padding;

  const CategoryWidget({Key key, @required this.categoryId, this.fontSize, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Categories.listByNetworkPOV[categoryId].color,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      padding: EdgeInsets.all(padding ?? 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            Categories.listByNetworkPOV[categoryId].icon +
                ' ' +
                Categories.listByNetworkPOV[categoryId].text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? 13.0,
            ),
          ),
        ],
      ),
    );
  }
}

class SimplifiedCategoryWidget extends StatelessWidget {
  final String categoryId;

  const SimplifiedCategoryWidget({Key key, @required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: CircleAvatar(
        radius: 8.0,
        backgroundColor: Categories.listByNetworkPOV[categoryId].color,
        foregroundColor: Colors.white,
        child: Text(
          Categories.listByNetworkPOV[categoryId].icon,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 7.0,
          ),
        ),
      ),
    );
  }
}

