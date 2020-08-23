import 'dart:async';
import 'dart:io';

import 'package:Eliverd/common/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:Eliverd/bloc/events/orderEvent.dart';
import 'package:Eliverd/bloc/orderBloc.dart';
import 'package:Eliverd/bloc/states/orderState.dart';

import 'package:Eliverd/ui/pages/order_display.dart';

class OrderPage extends StatefulWidget {
  final String redirectURL;

  const OrderPage({Key key, @required this.redirectURL}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              '주문',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: WebView(
            initialUrl: widget.redirectURL,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              if (_isKakaoPayScheme(request.url)) {
                _launchFromDeviceBrowser(request.url);

                return NavigationDecision.prevent;
              } else if (_isEliverdHandlerURL(request.url)) {
                if (request.url.contains('approve')) {
                  context.bloc<OrderBloc>().add(ApproveOrder(request.url));
                } else if (request.url.contains('cancel')) {
                  context.bloc<OrderBloc>().add(CancelOrder(request.url));
                } else if (request.url.contains('fail')) {
                  context.bloc<OrderBloc>().add(FailOrder(request.url));
                }

                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ),
        );
      },
      listener: (context, state) {
        if (state is! OrderInProgress) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDisplayPage(),
            ),
          );
        }
      },
    );
  }


  bool _isEliverdHandlerURL(String url) => url.contains('SECRET:8000/purchase');
  bool _isKakaoPayScheme(String url) => url.startsWith('kakaotalk:');

  void _launchFromDeviceBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotSupportedDeviceAlertDialog(context);
    }
  }
}

showNotSupportedDeviceAlertDialog(BuildContext context) {
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
      '결제 불가',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      'Eliverd는 카카오페이 결제를 지원하고 있습니다. 카카오페이 설치 후 다시 시도해주세요.',
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
      '결제 불가',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      ),
    ),
    content: Text(
      'Eliverd는 카카오페이 결제를 지원하고 있습니다. 카카오페이 설치 후 다시 시도해주세요.',
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
