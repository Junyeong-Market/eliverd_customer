import 'dart:convert';
import 'dart:io';

import 'package:Eliverd/ui/widgets/shopping_cart_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Eliverd/models/models.dart';
import 'package:Eliverd/ui/widgets/stock.dart';

import 'package:Eliverd/common/color.dart';

class ProductInfoPage extends StatelessWidget {
  final Stock stock;

  const ProductInfoPage({Key key, @required this.stock})
      : super(key: key);

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
          '상품 살펴보기',
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
        actions: [
          ShoppingCartButton(),
          ButtonTheme(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 0,
            height: 0,
            child: FlatButton(
              padding: EdgeInsets.only(
                right: 16.0,
              ),
              textColor: Colors.black,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text(
                '􀙊',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 24.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          SpecifiedStock(
            stock: stock,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0.0,
          child: CupertinoButton(
            child: Text(
              '장바구니에 담기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            color: eliverdColor,
            borderRadius: BorderRadius.circular(10.0),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            onPressed: () {
              _addToCart(context, stock);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, Stock product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> carts = prefs.getStringList('carts') ?? <String>[];

    String encoded = json.encode(product.toJson());

    if (carts.contains(encoded)) {
      showDuplicatedShoppingCartAlertDialog(context, stock);

      return;
    }

    carts.add(encoded);

    prefs.setStringList('carts', carts);

    showItemAddedAlertDialog(context, stock);
  }
}

showDuplicatedShoppingCartAlertDialog(BuildContext context, Stock stock) {
  Widget confirmButton = FlatButton(
    child: Text(
      '확인',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget cupertinoConfirmButton = CupertinoDialogAction(
    child: Text(
      '확인',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(
      '장바구니 중복',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      '\'' + stock.product.name + '\'상품은 이미 장바구니에 있는 상품입니다.',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    ),
    actions: <Widget>[
      confirmButton,
    ],
  );

  CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
    title: Text(
      '장바구니 중복',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      '\'' + stock.product.name + '\' 상품은 이미 장바구니에 있는 상품입니다.',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    ),
    actions: <Widget>[
      cupertinoConfirmButton,
    ],
  );

  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  } else if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return cupertinoAlertDialog;
      },
    );
  }
}

showItemAddedAlertDialog(BuildContext context, Stock stock) {
  Widget confirmButton = FlatButton(
    child: Text(
      '확인',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget cupertinoConfirmButton = CupertinoDialogAction(
    child: Text(
      '확인',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(
      '장바구니 추가 완료',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      '\'' + stock.product.name + '\' 상품이 장바구니에 성공적으로 추가되었습니다.',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    ),
    actions: <Widget>[
      confirmButton,
    ],
  );

  CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
    title: Text(
      '장바구니 추가 완료',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      '\'' + stock.product.name + '\' 상품이 장바구니에 성공적으로 추가되었습니다.',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    ),
    actions: <Widget>[
      cupertinoConfirmButton,
    ],
  );

  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  } else if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return cupertinoAlertDialog;
      },
    );
  }
}

