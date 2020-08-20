import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/pages/product_info.dart';
import 'package:Eliverd/ui/widgets/category.dart';

class StockList extends StatelessWidget {
  final List<Stock> stocks;

  const StockList({Key key, @required this.stocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.55,
      ),
      itemBuilder: (context, index) => SimplifiedStock(
        stock: stocks[index],
      ),
      itemCount: stocks.length,
    );
  }
}

class StockListOnCart extends StatelessWidget {
  final List<Stock> stocks;

  const StockListOnCart({Key key, @required this.stocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemBuilder: (context, index) => SimplifiedStockOnCart(
        stock: stocks[index],
      ),
      itemCount: stocks.length,
    );
  }
}

class SimplifiedStock extends StatelessWidget {
  final Stock stock;

  const SimplifiedStock({Key key, @required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInfoPage(
              stock: stock,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Container(
                  color: Colors.black12,
                  child: Center(
                    child: Text(
                      '사진 없음',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    stock.product.manufacturer.name,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 11.0,
                    ),
                  ),
                  Text(
                    stock.product.name,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13.0,
                    ),
                  ),
                  Text(
                    formattedPrice(stock.price),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(height: 1.6),
                  WidgetifiedCategory(
                    categoryId: stock.product.category,
                    fontSize: 9.0,
                    padding: 2.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formattedPrice(int price) {
    if (price >= 100000000) {
      return '₩' + (price / 100000000).toStringAsFixed(1) + '억';
    } else if (price >= 10000000) {
      return '₩' + (price / 10000).toStringAsFixed(1) + '만';
    }

    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}

class SpecifiedStock extends StatelessWidget {
  final Stock stock;

  const SpecifiedStock({Key key, @required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            color: Colors.black12,
            width: width,
            height: width,
            child: Center(
              child: Text(
                '누가 봐도 이 상품에 대한 사진',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.0),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                stock.product.manufacturer.name,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              Text(
                stock.product.name,
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 19.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedPrice(stock.price),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  WidgetifiedCategory(
                    categoryId: stock.product.category,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formattedPrice(int price) {
    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}

class SimplifiedStockOnCart extends StatelessWidget {
  final Stock stock;

  const SimplifiedStockOnCart({Key key, @required this.stock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInfoPage(
              stock: stock,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 0.0,
          right: 8.0,
          top: 8.0,
          bottom: 0.0,
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(
                  height: width * 0.25,
                ),
                child: Container(
                  color: Colors.black12,
                  child: Center(
                    child: Text(
                      '사진 없음',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.0),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stock.product.manufacturer.name,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              stock.product.name,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 1.6),
                            WidgetifiedCategory(
                              categoryId: stock.product.category,
                              fontSize: 9.0,
                              padding: 2.0,
                            ),
                          ],
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
                              fontSize: 18.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '수량 선택',
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          formattedPrice(stock.price),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formattedPrice(int price) {
    if (price >= 100000000) {
      return '₩' + (price / 100000000).toStringAsFixed(1) + '억';
    } else if (price >= 10000000) {
      return '₩' + (price / 10000).toStringAsFixed(1) + '만';
    }

    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}
