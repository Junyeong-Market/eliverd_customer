import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Eliverd/ui/widgets/header.dart';
import 'package:Eliverd/ui/pages/home.dart';

class MyPagePage extends StatefulWidget {
  @override
  _MyPagePageState createState() => _MyPagePageState();
}

class _MyPagePageState extends State<MyPagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Header(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        title: '마이페이지',
      ),
      body: ListView(
      ),
    );
  }
}
