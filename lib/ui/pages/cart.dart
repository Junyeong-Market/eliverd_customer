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
  bool isShoppingCartEmpty = true;

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
      body: FutureBuilder<List<Stock>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return snapshot.data.isEmpty ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    Text(
                      '아무 상품도 없네요.\n얼른 상품을 담으러 둘러보세요! 👀',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ) : StockListOnCart(
                stocks: snapshot.data,
                removeHandler: (Stock stock) {
                  setState(() {
                    products = _removeFromCart(stock);
                  });
                },
              );
            } else if (snapshot.hasError) {
              return Text(
                '장바구니를 불러오는 중 오류가 발생했습니다.\n다시 시도해주세요.',
                style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              );
            }
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoActivityIndicator(),
                SizedBox(height: 4.0),
                Text(
                  '장바구니를 불러오고 있습니다.\n잠시만 기다려주세요!',
                  style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '총합: ₩0',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 4.0),
              CupertinoButton(
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
                onPressed: isShoppingCartEmpty ? null : () {},
              ),
            ],
          )
        ),
      ),
    );
  }

  Future<List<Stock>> _fetchShoppingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> rawProducts = prefs.getStringList('carts') ?? <String>[];

    if (rawProducts.isEmpty) {
      setState(() {
        isShoppingCartEmpty = true;
      });
    } else {
      setState(() {
        isShoppingCartEmpty = false;
      });
    }

    return rawProducts
        .map((rawProduct) => Stock.fromJson(json.decode(rawProduct)))
        .toList();
  }

  Future<List<Stock>> _removeFromCart(Stock stock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> carts = prefs.getStringList('carts') ?? <String>[];

    carts.remove(json.encode(stock.toJson()));

    prefs.setStringList('carts', carts);

    if (carts.isEmpty) {
      setState(() {
        isShoppingCartEmpty = true;
      });
    }

    return carts
        .map((rawProduct) => Stock.fromJson(json.decode(rawProduct)))
        .toList();
  }
}
