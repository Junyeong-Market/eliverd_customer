import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/bloc/events/orderEvent.dart';
import 'package:Eliverd/bloc/states/orderState.dart';
import 'package:Eliverd/bloc/orderBloc.dart';

import 'package:Eliverd/ui/widgets/stock.dart';
import 'package:Eliverd/ui/widgets/search_location.dart';
import 'package:Eliverd/ui/pages/order.dart';

import 'package:Eliverd/common/color.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  Future<List<Stock>> cartItems;
  Future<String> shippingAddress;
  ValueNotifier<List<int>> amounts;

  bool isShoppingCartEmpty = true;
  bool isPriceExceeded = false;
  bool isExceedLimitAlertDisplayed = false;

  Coordinate shippingDestination;

  @override
  void initState() {
    super.initState();

    cartItems = _fetchShoppingCart();
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
                  if (isShoppingCartEmpty) {
                    Navigator.pop(context);
                    return;
                  }

                  showConfirmExitAlertDialog(context);
                },
              ),
            ),
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              '장바구니',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            ),
            actions: [
              ButtonTheme(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minWidth: 0,
                height: 0,
                child: FlatButton(
                  padding: EdgeInsets.only(
                    right: 16.0,
                  ),
                  textColor: Colors.black,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    '􀋑',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 24.0,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SearchLocationDialog(
                        onLocationSelected: _onShippingDestinationSelected,
                      ),
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: FutureBuilder<List<Stock>>(
            future: cartItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return snapshot.data.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 16.0),
                              Text(
                                '아무 상품도 없네요.\n얼른 상품을 담으러 둘러보세요! 👀',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : StockListOnCart(
                          stocks: snapshot.data,
                          amounts: amounts,
                          removeHandler: (Stock stock) {
                            int index = snapshot.data.indexOf(stock);

                            setState(() {
                              cartItems =
                                  _removeFromCart(index).whenComplete(() {
                                List<int> newAmounts = List.of(amounts.value);

                                newAmounts.removeAt(index);

                                amounts.value = newAmounts;
                              });
                            });
                          },
                        );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonTheme(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          minWidth: 0,
                          height: 0,
                          child: FlatButton(
                            padding: EdgeInsets.all(0.0),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            textColor: Colors.black12,
                            child: Text(
                              '⟳',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 48.0,
                              ),
                            ),
                            onPressed: () {
                              cartItems = _fetchShoppingCart();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                          ),
                        ),
                        Text(
                          '장바구니를 불러오는 중 오류가 발생했습니다.\n다시 시도해주세요.',
                          style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
              }

              return Center(
                child: CupertinoActivityIndicator(),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(8.0),
            child: BottomAppBar(
              color: Colors.transparent,
              elevation: 0.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<List<Stock>>(
                    future: cartItems,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return ValueListenableBuilder(
                          valueListenable: amounts,
                          builder: (BuildContext context, List<int> amounts,
                              Widget child) {
                            int total = 0;

                            for (int i = 0; i < amounts.length; i++) {
                              total += snapshot.data[i].price * amounts[i];
                            }

                            final formatted = formattedPrice(total);

                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                isPriceExceeded = total > 1000000;
                              });

                              if (isPriceExceeded &&
                                  !isExceedLimitAlertDisplayed) {
                                showExceededLimitAlertDialog(context);

                                setState(() {
                                  isExceedLimitAlertDisplayed = true;
                                });
                              }
                            });

                            return Text(
                              '총합: $formatted',
                              style: TextStyle(
                                color:
                                    isPriceExceeded ? Colors.red : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.right,
                            );
                          },
                        );
                      }

                      return Text(
                        '총합: ${formattedPrice(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.right,
                      );
                    },
                  ),
                  FutureBuilder<String>(
                    future: shippingAddress,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Text(
                          '${snapshot.data}\n로 배송 예정',
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.right,
                        );
                      }

                      return Text(
                        '배송 없음',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.right,
                      );
                    },
                  ),
                  SizedBox(height: 4.0),
                  CupertinoButton(
                    child: Text(
                      '주문하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    color: eliverdColor,
                    borderRadius: BorderRadius.circular(10.0),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: isReadyToOrder
                        ? () {
                            cartItems.then((items) => context
                                .bloc<OrderBloc>()
                                .add(ProceedOrder(items, amounts.value,
                                    shippingDestination)));
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is OrderInProgress) {
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

  bool get isDeliveryDestinationSelected => shippingDestination != null;

  bool get isReadyToOrder =>
      !isShoppingCartEmpty && !isPriceExceeded && isDeliveryDestinationSelected;

  Future<List<Stock>> _fetchShoppingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> rawProducts = prefs.getStringList('carts') ?? <String>[];

    if (rawProducts.isEmpty) {
      setState(() {
        isShoppingCartEmpty = true;
      });
    } else {
      setState(() {
        isShoppingCartEmpty = false;
      });
    }

    amounts = ValueNotifier<List<int>>(
        List<int>.generate(rawProducts.length, (index) => 1));

    return rawProducts
        .map((rawProduct) => Stock.fromJson(json.decode(rawProduct)))
        .toList();
  }

  Future<List<Stock>> _removeFromCart(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> carts = prefs.getStringList('carts') ?? <String>[];

    carts.removeAt(index);

    prefs.setStringList('carts', carts);

    if (carts.isEmpty) {
      setState(() {
        isShoppingCartEmpty = true;
      });
    }

    return carts
        .map((rawProduct) => Stock.fromJson(json.decode(rawProduct)))
        .toList();
  }

  void _onShippingDestinationSelected(Coordinate coordinate) {
    final position = LatLng(coordinate.lat, coordinate.lng);

    setState(() {
      shippingDestination = coordinate;
      shippingAddress = _getAddressFromPosition(position);
    });
  }

  Future<String> _getAddressFromPosition(LatLng position) async {
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: 'ko_KR',
    );

    return placemarks
        .map((placemark) =>
            '${placemark.country} ${placemark.administrativeArea} ${placemark.locality} ${placemark.name} ${placemark.postalCode}')
        .join(',');
  }

  String formattedPrice(int price) {
    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}

showExceededLimitAlertDialog(BuildContext context) {
  Widget confirmButton = FlatButton(
    child: Text(
      '확인',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget cupertinoConfirmButton = CupertinoDialogAction(
    child: Text(
      '확인',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(
      '주문 금액 한도 초과',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      'Eliverd는 현재 백만 원(1,000,000원)까지만 결제할 수 있습니다. 한도 이상의 금액은 주문을 여러 차례 나누어 진행해주세요.',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    ),
    actions: <Widget>[
      confirmButton,
    ],
  );

  CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
    title: Text(
      '주문 금액 한도 초과',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      'Eliverd는 현재 백만 원(1,000,000원)까지만 결제할 수 있습니다. 한도 이상의 금액은 주문을 여러 차례 나누어 진행해주세요.',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    ),
    actions: <Widget>[
      cupertinoConfirmButton,
    ],
  );

  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  } else if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return cupertinoAlertDialog;
      },
    );
  }
}

showConfirmExitAlertDialog(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text(
      '취소',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w400,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget confirmButton = FlatButton(
    child: Text(
      '확인',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  Widget cupertinoCancelButton = CupertinoDialogAction(
    child: Text(
      '취소',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w400,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget cupertinoConfirmButton = CupertinoDialogAction(
    child: Text(
      '확인',
      style: TextStyle(
        color: eliverdColor,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(
      '정말로 나가시겠습니까?',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      '장바구니에서 설정한 수량과 배송지 정보가 초기화됩니다(단, 장바구니 목록은 삭제되지 않습니다).',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    ),
    actions: <Widget>[
      cancelButton,
      confirmButton,
    ],
  );

  CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
    title: Text(
      '정말로 나가시겠습니까?',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      '장바구니에서 설정한 수량과 배송지 정보가 초기화됩니다(단, 장바구니 목록은 삭제되지 않습니다).',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    ),
    actions: <Widget>[
      cupertinoCancelButton,
      cupertinoConfirmButton,
    ],
  );

  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  } else if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return cupertinoAlertDialog;
      },
    );
  }
}
