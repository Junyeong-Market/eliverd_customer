import 'dart:async';

import 'package:flutter/material.dart';

import 'package:Eliverd/common/string.dart';
import './login.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('SplashScreenPage'),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(title),
      ),
    );
  }
}