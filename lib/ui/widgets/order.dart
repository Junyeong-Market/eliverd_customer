import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/widgets/stock.dart';

class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    final orderedStocks = order.partials
        .map((PartialOrder partial) => partial.stocks)
        .expand((e) => e)
        .toList();

    final total = order.partials.map((PartialOrder partial) => partial.stocks)
        .expand((e) => e).toList().map((OrderedStock orderedStock) =>
    orderedStock.stock.price * orderedStock.amount)
        .reduce((a, b) => a + b);

    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${order.id}번 주문',
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Text(
            '주문자: ${order.customer.realname}(${order.customer.nickname})',
          ),
          Text(
            '주문 상품 목록',
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Container(
            width: width * 0.9,
            height: height * 0.5,
            child: StockListOnOrder(
              orderedStocks: orderedStocks,
            ),
          ),
          Text(
            '총합: ${formattedPrice(total)}',
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ],
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
