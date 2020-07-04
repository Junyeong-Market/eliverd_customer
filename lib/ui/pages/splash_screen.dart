import 'dart:async';

import 'package:Eliverd/common/key.dart';
import 'package:flutter/material.dart';

import 'package:Eliverd/common/color.dart';

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
      Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return _buildSplashScreen(width);
  }

  Widget _buildSplashScreen(double width) => Scaffold(
        key: SplashScreenKeys.splashScreenPage,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          key: SplashScreenKeys.splashScreenBackground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [eliverdLightColor, eliverdDarkColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Center(
            child: Image(
              key: SplashScreenKeys.splashScreenLogo,
              width: width / 1.5,
              height: width / 1.5,
              image: AssetImage('assets/images/logo/eliverd_logo_white.png'),
            ),
          ),
        ),
      );
}
