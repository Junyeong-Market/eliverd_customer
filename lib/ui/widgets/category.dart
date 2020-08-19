import 'package:Eliverd/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetifiedCategory extends StatelessWidget {
  final String categoryId;
  final double fontSize;
  final double padding;

  const WidgetifiedCategory({Key key, @required this.categoryId, this.fontSize, this.padding}) : super(key: key);

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
