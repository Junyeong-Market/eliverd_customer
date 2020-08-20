import 'dart:async';
import 'dart:convert';

import 'package:Eliverd/ui/widgets/stock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/common/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  Future<List<Stock>> products;

  @override
  void initState() {
    super.initState();

    products = _fetchShoppingCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ButtonTheme(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minWidth: 0,
          height: 0,
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            textColor: Colors.black,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              '􀆉',
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 24.0,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          '장바구니',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: Colors.black12,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(0.0),
        ),
      ),
      body: FutureBuilder(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return StockListOnCart(
                stocks: snapshot.data,
              );
            } else if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
              );
            }
          }

          return Text(
            '불러오고 있음!',
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0.0,
          child: CupertinoButton(
            child: Text(
              '주문하기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            color: eliverdColor,
            borderRadius: BorderRadius.circular(5.0),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Future<List<Stock>> _fetchShoppingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> rawProducts = prefs.getStringList('carts') ?? <String>[];

    return rawProducts
        .map((rawProduct) => Stock.fromJson(json.decode(rawProduct)))
        .toList();
  }

  // TO-DO: 장바구니 목록 삭제 기능 재구현
  /*
  Future<List<Stock>> _removeFromCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> carts = prefs.getStringList('carts') ?? <String>[];

    carts.removeLast();

    prefs.setStringList('carts', carts);

    return carts
        .map((rawProduct) => Stock.fromJson(json.decode(rawProduct)))
        .toList();
  }
   */
}
