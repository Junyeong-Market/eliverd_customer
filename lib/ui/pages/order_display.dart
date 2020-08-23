import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/bloc/orderBloc.dart';
import 'package:Eliverd/bloc/states/orderState.dart';

class OrderDisplayPage extends StatefulWidget {
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
              '주문 ${state is OrderApproved ? '완료' : (state is OrderCanceled ? '취소' : (state is OrderFailed ? '실패' : ''))}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: Text(
            state is OrderApproved
                ? state.order.toString()
                : (state is OrderCanceled
                    ? state.order.toString()
                    : (state is OrderFailed ? state.order.toString() : '')),
          ),
        );
      },
      listener: (context, state) {
        if (state is OrderInProgress) {
          Navigator.pop(context);
        }
      },
    );
  }
}
