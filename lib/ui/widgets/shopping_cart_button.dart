import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Eliverd/ui/pages/cart.dart';

class ShoppingCartButton extends StatefulWidget {
  @override
  _ShoppingCartButtonState createState() => _ShoppingCartButtonState();
}

class _ShoppingCartButtonState extends State<ShoppingCartButton> {
  Future<int> quantity;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        setState(() {
          quantity = _fetchShoppingCartQuantity();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 0,
      height: 0,
      child: FlatButton(
        padding: EdgeInsets.only(
          right: 4.0,
        ),
        textColor: Colors.black,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Text(
              '􀍩',
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 24.0,
                color: Colors.black,
              ),
            ),
            FutureBuilder<int>(
              future: quantity,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: CircleAvatar(
                      radius: 8.0,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      child: Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShoppingCartPage(),
            ),
          );
        },
      ),
    );
  }

  Future<int> _fetchShoppingCartQuantity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> rawProducts = prefs.getStringList('carts');

    return rawProducts?.length ?? 0;
  }
}
