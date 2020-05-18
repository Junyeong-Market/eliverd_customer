import 'package:flutter/material.dart';

import 'package:Eliverd/ui/pages/splash_screen.dart';

void main() {
  runApp(EliverdCustomer());
}

class EliverdCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreenPage(),
    );
  }
}