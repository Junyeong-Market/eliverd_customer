import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:Eliverd/models/models.dart';

class StockList extends StatefulWidget {
  final List<Stock> stocks;
  final ValueChanged<Stock> onCartsChanged;

  const StockList(
      {Key key, @required this.stocks, @required this.onCartsChanged})
      : super(key: key);

  @override
  StockListState createState() => StockListState();
}

class StockListState extends State<StockList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) => ShowableStock(
        stock: widget.stocks[index],
        currentStore: widget.stocks[index].store,
        toggleCart: () {
          widget.onCartsChanged(widget.stocks[index]);
        },
      ),
      itemCount: widget.stocks.length,
    );
  }
}

class ShowableStock extends StatelessWidget {
  final Stock stock;
  final Store currentStore;
  final Function toggleCart;

  const ShowableStock(
      {Key key,
      @required this.stock,
      @required this.currentStore,
      @required this.toggleCart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
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
            SizedBox(height: 4.0),
            Text(
              formattedPrice(stock.price),
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
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
