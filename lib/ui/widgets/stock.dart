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
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.6,
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
