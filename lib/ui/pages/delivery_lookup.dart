import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryLookupPage extends StatefulWidget {
  @override
  _DeliveryLookupPageState createState() => _DeliveryLookupPageState();
}

class _DeliveryLookupPageState extends State<DeliveryLookupPage> {

  @override
  Widget build(BuildContext context) {
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
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
