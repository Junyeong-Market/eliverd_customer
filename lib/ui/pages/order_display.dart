import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Eliverd/bloc/orderBloc.dart';
import 'package:Eliverd/bloc/states/orderState.dart';

import 'package:Eliverd/ui/widgets/order.dart';

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
              '주문 ${state is OrderApproved ? '완료' : (state is OrderCanceled ? '취소' : (state is OrderFailed ? '실패' : '중 오류 발생'))}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: state is OrderApproved
              ? ListView(
                  children: [OrderWidget(order: state.order)],
                )
              : (state is OrderCanceled
                  ? ListView(
                      children: [OrderWidget(order: state.order)],
                    )
                  : (state is OrderFailed
                      ? ListView(
                          children: [OrderWidget(order: state.order)],
                        )
                      : Center(
                          child: Text(
                            '주문 중 예기치 않은 오류가 발생했습니다.\n나중에 다시 시도해주세요.',
                            style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ))),
        );
      },
      listener: (context, state) {
        if (state is OrderInProgress) {
          Navigator.pop(context);
        }

        if (state is OrderApproved) {
          _removeShoppingCart();
        }
      },
    );
  }

  Future<void> _removeShoppingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('carts');
  }
}
