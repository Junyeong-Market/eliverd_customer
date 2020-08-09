import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/common/color.dart';
import 'package:Eliverd/common/string.dart';

import 'package:Eliverd/ui/widgets/cart.dart';

class ShoppingCartDialog extends StatefulWidget {
  final List<Stock> carts;
  final ValueChanged<Stock> removeFromCart;

  const ShoppingCartDialog({Key key, @required this.carts, @required this.removeFromCart}) : super(key: key);

  @override
  ShoppingCartDialogState createState() => ShoppingCartDialogState();
}

class ShoppingCartDialogState extends State<ShoppingCartDialog> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: width * 0.85,
          height: height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    HomePageStrings.cart,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ButtonTheme(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minWidth: 0,
                    height: 0,
                    child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      textColor: Colors.black,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text(
                        '􀆄',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 4,
                child: CartList(
                  carts: widget.carts,
                  removeFromCart: (stock) {
                    setState(() {
                      widget.removeFromCart(stock);
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: Text(
                  HomePageStrings.order,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                color: eliverdColor,
                borderRadius: BorderRadius.circular(25.0),
                padding: EdgeInsets.symmetric(vertical: 15.0),
                onPressed: widget.carts.length != 0 ? () {} : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

}