import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/common/color.dart';

class CartList extends StatefulWidget {
  final List<Stock> carts;
  final ValueChanged<Stock> removeFromCart;

  const CartList({Key key, @required this.carts, @required this.removeFromCart})
      : super(key: key);

  @override
  CartListState createState() => CartListState();
}

class CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return widget.carts.length != 0
        ? ListView.builder(
            itemBuilder: (context, index) => ShowableCart(
              stock: widget.carts[index],
              removeFromCart: () {
                setState(() {
                  widget.removeFromCart(widget.carts[index]);
                });
              },
            ),
            itemCount: widget.carts.length,
          )
        : Text(
            '장바구니가 비어 있습니다!',
          );
  }
}

class ShowableCart extends StatelessWidget {
  final Stock stock;
  final Function removeFromCart;

  const ShowableCart(
      {Key key, @required this.stock, @required this.removeFromCart})
      : super(key: key);

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
                        stock.product.name,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        stock.product.manufacturer.name,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        formattedPrice(stock.price),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ButtonTheme(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minWidth: 0,
                      height: 0,
                      child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        textColor: eliverdColor,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text(
                          '􀍭',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24.0,
                          ),
                        ),
                        onPressed: removeFromCart,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '주문 수량',
                        ),
                        Container(
                          width: 50.0,
                          height: 50.0,
                          child: CupertinoPicker.builder(
                            itemExtent: 32.0,
                            onSelectedItemChanged: (index) {},
                            itemBuilder: (context, index) {
                              return Text(
                                index.toString(),
                              );
                            },
                            childCount: stock.amount + 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formattedPrice(int price) {
    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}
