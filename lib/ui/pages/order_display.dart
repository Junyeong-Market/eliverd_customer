
import 'package:Eliverd/common/color.dart';
import 'package:Eliverd/ui/pages/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Eliverd/bloc/events/orderEvent.dart';
import 'package:Eliverd/bloc/orderBloc.dart';
import 'package:Eliverd/bloc/states/orderState.dart';
import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/widgets/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDisplayPage extends StatefulWidget {
  final Order order;

  const OrderDisplayPage({Key key, this.order}) : super(key: key);

  @override
  _OrderDisplayPageState createState() => _OrderDisplayPageState();
}

class _OrderDisplayPageState extends State<OrderDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      builder: (context, state) {
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
              '주문 상세 조회',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: ListView(
            children: [
              OrderWidget(
                order: widget.order,
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
                  '재주문',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                color: eliverdColor,
                borderRadius: BorderRadius.circular(10.0),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                onPressed: widget.order.status == 'processed'
                    ? null
                    : () {
                        context.bloc<OrderBloc>().add(
                              ContinueOrder(
                                widget.order.id,
                              ),
                            );
                      },
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is OrderInResume) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderPage(
                redirectURL: state.redirectURL,
              ),
            ),
          );
        }
      },
    );
  }
}
