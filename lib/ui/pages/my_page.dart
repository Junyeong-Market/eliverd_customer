import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:Eliverd/bloc/userBloc.dart';

import 'package:Eliverd/resources/providers/accountProvider.dart';
import 'package:Eliverd/resources/repositories/accountRepository.dart';

import 'package:Eliverd/common/color.dart';

import 'package:Eliverd/ui/widgets/user_profile.dart';
import 'package:Eliverd/ui/pages/order_lookup.dart';

class MyPagePage extends StatefulWidget {
  @override
  _MyPagePageState createState() => _MyPagePageState();
}

class _MyPagePageState extends State<MyPagePage> {
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _userBloc = UserBloc(
      accountRepository: AccountRepository(
        accountAPIClient: AccountAPIClient(
          httpClient: http.Client(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }

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
          '마이페이지',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        children: [
          UserProfile(
            userBloc: _userBloc,
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text(
                '일반',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderLookupPage(),
                ),
              );
            },
            child: _buildOrderLookupButton(),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderLookupPage(),
                ),
              );
            },
            child: _buildChangeProfileButton(),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text(
                '계정 관리',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          GestureDetector(
            onTap: () {},
            child: _buildLogoutButton(),
          ),
          SizedBox(
            height: 8.0,
          ),
          GestureDetector(
            onTap: () {},
            child: _buildCloseAccountButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderLookupButton() => Card(
        margin: EdgeInsets.zero,
        elevation: 0.0,
        color: Colors.transparent,
        shape: Border(
          top: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 15,
                child: Text(
                  '주문 내역 조회',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Flexible(
                child: Text(
                  '􀆊',
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildChangeProfileButton() => Card(
        margin: EdgeInsets.zero,
        elevation: 0.0,
        color: Colors.transparent,
        shape: Border(
          top: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 15,
                child: Text(
                  '프로필 수정',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Flexible(
                child: Text(
                  '􀆊',
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildLogoutButton() => Card(
        margin: EdgeInsets.zero,
        elevation: 0.0,
        color: Colors.transparent,
        shape: Border(
          top: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Text(
            '로그아웃',
            style: TextStyle(
              color: eliverdDarkColor,
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _buildCloseAccountButton() => Card(
        margin: EdgeInsets.zero,
        elevation: 0.0,
        color: Colors.transparent,
        shape: Border(
          top: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Text(
            '회원 탈퇴',
            style: TextStyle(
              color: eliverdDarkColor,
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
