import 'package:Eliverd/bloc/deliveryBloc.dart';
import 'package:Eliverd/bloc/events/deliveryEvent.dart';
import 'package:Eliverd/bloc/states/deliveryState.dart';
import 'package:Eliverd/ui/widgets/delivery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryLookupPage extends StatefulWidget {
  @override
  _DeliveryLookupPageState createState() => _DeliveryLookupPageState();
}

class _DeliveryLookupPageState extends State<DeliveryLookupPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    context.bloc<DeliveryBloc>().add(FetchDeliveries());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryBloc, DeliveryState>(
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
              '남은 배달 내역',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: state is DeliveryFetched
              ? (state.deliveries.isEmpty
                  ? Center(
                      child: Text(
                        '배달할 상품이 하나도 없네요.\n이럴 때 잠깐 휴식을 가져보세요!😎',
                        style: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.deliveries.length
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
                                            '여기까지 ${state.deliveries.length}의 배달을 처리해야 합니다.',
                                            style: TextStyle(
                                              color: Colors.black26,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    : CupertinoActivityIndicator(),
                              )
                            : DeliveryWidget(
                                partialOrder: state.deliveries[index],
                              );
                      },
                      itemCount: state.isAllFetched
                          ? state.deliveries.length
                          : state.deliveries.length + 1,
                      controller: _scrollController,
                    ))
              : (state is DeliveryError
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          ButtonTheme(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            minWidth: 0,
                            height: 0,
                            child: FlatButton(
                              padding: EdgeInsets.all(0.0),
                              textColor: Colors.black12,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Text(
                                '⟳',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 48.0,
                                ),
                              ),
                              onPressed: () {
                                context
                                    .bloc<DeliveryBloc>()
                                    .add(FetchDeliveries());
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                          ),
                          Text(
                            '배달 내역을 불러오는 중 오류가 발생했습니다.\n다시 시도해주세요.',
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
                      child: CupertinoActivityIndicator(),
                    )),
        );
      },
    );
  }

  void _onScroll() {
    if (_isBottom && !_isAllFetched)
      context.bloc<DeliveryBloc>().add(FetchDeliveries());
  }

  bool get _isAllFetched {
    final currentState = context.bloc<DeliveryBloc>().state;

    if (currentState is DeliveryFetched) {
      return currentState.isAllFetched;
    }

    return false;
  }

  bool get _isBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll;
  }
}
