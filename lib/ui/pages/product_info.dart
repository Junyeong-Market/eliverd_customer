import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          ButtonTheme(
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
              child: Text(
                '􀍩',
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
            borderRadius: BorderRadius.circular(5.0),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
