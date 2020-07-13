import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/common/color.dart';

class ShowableStock extends StatefulWidget {
  final Stock stock;
  final Store currentStore;

  const ShowableStock({Key key, @required this.stock, @required this.currentStore}) : super(key: key);

  @override
  _ShowableStockState createState() => _ShowableStockState();
}

class _ShowableStockState extends State<ShowableStock> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      color: Colors.transparent,
      shape: Border(
        bottom: BorderSide(
          color: Colors.black12,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.stock.product.name,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        widget.stock.product.manufacturer.name,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ButtonTheme(
                      materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                      minWidth: 0,
                      height: 0,
                      child: FlatButton(
                        padding: EdgeInsets.all(1.0),
                        textColor: eliverdColor,
                        child: Text(
                          '􀍫',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24.0,
                          ),
                        ),
                        onPressed: () {
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  formattedPrice(widget.stock.price),
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
                _buildAmountText(widget.stock.amount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountText(int amount) {
    String text;
    TextStyle textStyle;

    if (amount == 0) {
      text = '재고 소진됨';
      textStyle = const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w800,
        fontSize: 14.0,
      );
    } else if (amount == 1) {
      text = '서두르세요! $amount개 남음';
      textStyle = const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w800,
        fontSize: 14.0,
      );
    } else {
      text = '현재 $amount개 남음';
      textStyle = const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w300,
        fontSize: 14.0,
      );
    }

    return Text(
      text,
      style: textStyle,
    );
  }

  String formattedPrice(int price) {
    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}
