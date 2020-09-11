import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/widgets/stock.dart';

class DeliveryWidget extends StatefulWidget {
  final PartialOrder partialOrder;

  const DeliveryWidget({Key key, @required this.partialOrder})
      : super(key: key);

  @override
  _DeliveryWidgetState createState() => _DeliveryWidgetState();
}

class _DeliveryWidgetState extends State<DeliveryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (var orderedStock in widget.partialOrder.stocks)
          StockOnDelivery(
            orderedStock: orderedStock,
          ),
      ],
    );
  }
}
