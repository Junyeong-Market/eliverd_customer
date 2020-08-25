import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/bloc/events/orderEvent.dart';
import 'package:Eliverd/bloc/orderBloc.dart';
import 'package:Eliverd/bloc/states/orderState.dart';

import 'package:Eliverd/ui/widgets/order.dart';

class OrderLookupPage extends StatefulWidget {
  @override
  _OrderLookupPageState createState() => _OrderLookupPageState();
}

class _OrderLookupPageState extends State<OrderLookupPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    context.bloc<OrderBloc>().add(FetchOrder());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              '주문 내역',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: state is OrderFetched
              ? ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.orders.length
                        ? Center(
                            child: state.isAllFetched
                                ? Column(
                                    children: [
                                      Divider(
                                        height: 16.0,
                                        indent: 160.0,
                                        endIndent: 160.0,
                                        thickness: 2.4,
                                        color: Colors.black12,
                                      ),
                                      Text(
                                        '여기까지 ${state.orders.length}번 주문하셨습니다.',
                                        style: TextStyle(
                                          color: Colors.black26,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : CupertinoActivityIndicator(),
                          )
                        : OrderWidget(order: state.orders[index]);
                  },
                  itemCount: state.isAllFetched
                      ? state.orders.length
                      : state.orders.length + 1,
                  controller: _scrollController,
                )
              : (state is OrderError
                  ? Center(
                      child: Column(
                        children: [
                          ButtonTheme(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            minWidth: 0,
                            height: 0,
                            child: FlatButton(
                              padding: EdgeInsets.all(0.0),
                              textColor: Colors.black12,
                              child: Text(
                                '⟳',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 56.0,
                                ),
                              ),
                              onPressed: () {
                                context.bloc<OrderBloc>().add(FetchOrder());
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            '주문 내역을 불러오는 중 오류가 발생했습니다.\n다시 시도해주세요.',
                            style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '주문 내역을 불러오고 있습니다.\n잠시만 기다려주세요.',
                            style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.0),
                          CupertinoActivityIndicator(),
                        ],
                      ),
                    )),
        );
      },
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is OrderFetched && !state.isAllFetched && _isBottom) {
            context.bloc<OrderBloc>().add(FetchOrder());
          }
        });
      },
    );
  }

  void _onScroll() {
    if (_isBottom) context.bloc<OrderBloc>().add(FetchOrder());
  }

  bool get _isBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
