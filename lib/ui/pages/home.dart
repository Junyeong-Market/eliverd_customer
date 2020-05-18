import 'package:flutter/material.dart';

import 'package:Eliverd/common/string.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('HomePage'),
      body: Center(child: Text(title))
    );
  }
}