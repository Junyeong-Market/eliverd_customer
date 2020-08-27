import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/widgets/stock.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({Key key, @required this.order}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Future<String> shippingAddress;

  @override
  void initState() {
    super.initState();


    shippingAddress = _getAddressFromCoordinate(widget.order.destination);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.order.partials
        .map((PartialOrder partial) => partial.stocks)
        .expand((e) => e)
        .toList()
        .map((OrderedStock orderedStock) =>
            orderedStock.stock.price * orderedStock.amount)
        .reduce((a, b) => a + b);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '주문 번호 ${widget.order.id}번(${widget.order.tid})',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          for (var partialOrder in widget.order.partials)
            PartialOrderWidget(
              partialOrder: partialOrder,
            ),
          Divider(
            height: 4.0,
            thickness: 1.0,
            color: Colors.black,
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '총 결제 금액',
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              Text(
                '${formattedPrice(total)}',
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  fontSize: 22.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '입금자',
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              Text(
                widget.order.customer.realname,
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '승인 상태',
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              Text(
                widget.order.status == 'processed'
                    ? '결제 완료'
                    : (widget.order.status == 'canceled'
                        ? '결제 취소'
                        : (widget.order.status == 'failed' ? '결제 실패' : '확인 불가')),
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '배송지',
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: FutureBuilder<String>(
                  future: shippingAddress,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Text(
                        snapshot.data.isEmpty ? '없음' : snapshot.data,
                        maxLines: 2,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      );
                    }

                    return CupertinoActivityIndicator();
                  },
                ),
              ),
            ],
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

  Future<String> _getAddressFromCoordinate(Coordinate coordinate) async {
    if (coordinate == null) {
      return '';
    }

    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(
      coordinate.lat,
      coordinate.lng,
      localeIdentifier: 'ko_KR',
    );

    return placemarks
        .map((placemark) =>
            '${placemark.country} ${placemark.administrativeArea} ${placemark.locality} ${placemark.name} ${placemark.postalCode}')
        .join(',');
  }
}

class PartialOrderWidget extends StatelessWidget {
  final PartialOrder partialOrder;

  const PartialOrderWidget({Key key, @required this.partialOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int semiTotal = partialOrder.stocks
        .map((OrderedStock orderedStock) =>
            orderedStock.stock.price * orderedStock.amount)
        .reduce((a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Divider(
          height: 4.0,
          thickness: 1.0,
          color: Colors.black,
        ),
        for (var orderedStock in partialOrder.stocks)
          StockOnOrder(
            orderedStock: orderedStock,
          ),
        SizedBox(
          height: 8.0,
        ),
        Divider(
          height: 4.0,
          thickness: 1.0,
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '점포명',
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            Text(
              partialOrder.store.name,
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '대표자',
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            Text(
              '${partialOrder.store.registerers[0].realname}' +
                  (partialOrder.store.registerers.length == 1
                      ? ''
                      : '외 ${partialOrder.store.registerers.length - 1}명'),
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '사업자등록번호',
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            Text(
              formattedRegistererNumber(partialOrder.store.registeredNumber),
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '소계',
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            Text(
              '${formattedPrice(semiTotal)}',
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                fontSize: 17.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
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

  String formattedRegistererNumber(String value) {
    return value.substring(0, 3) +
        '-' +
        value.substring(3, 5) +
        '-' +
        value.substring(5);
  }
}
