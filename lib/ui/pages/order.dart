import 'dart:async';

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
              print(request.url);

              if (request.url.startsWith('kakaotalk')) {
                _launchURL(request.url);

                return NavigationDecision.prevent;
              } else if (request.url.contains('SECRET:8000/purchase')) {
                if (request.url.contains('approve')) {
                  context.bloc<OrderBloc>().add(ApproveOrder(request.url));
                } else if (request.url.contains('cancel')) {
                  context.bloc<OrderBloc>().add(CancelOrder(request.url));
                } else if (request.url.contains('fail')) {
                  context.bloc<OrderBloc>().add(FailOrder(request.url));
                }
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
