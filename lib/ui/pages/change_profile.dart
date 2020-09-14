import 'package:Eliverd/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/bloc/userBloc.dart';
import 'package:Eliverd/bloc/events/userEvent.dart';
import 'package:Eliverd/bloc/states/userState.dart';

import 'package:Eliverd/common/color.dart';

class ChangeProfilePage extends StatefulWidget {
  final UserBloc userBloc;

  const ChangeProfilePage({Key key, @required this.userBloc}) : super(key: key);

  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final _nicknameController = TextEditingController();
  final _realnameController = TextEditingController();

  User previous;
  bool _isUserFetched = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<UserBloc, UserState>(
      cubit: widget.userBloc,
      builder: (context, state) {

        if (state is UserInfoFetched && !_isUserFetched) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              previous = state.user;
              _isUserFetched = true;
            });

            _nicknameController.text = previous.nickname;
            _realnameController.text = previous.realname;
          });
        }

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
              '프로필 수정',
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
            children: <Widget>[
              if (state is UserInfoFetched)
                Column(
                  children: [
                    Container(
                      width: width * 0.3,
                      height: width * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black54, Colors.black26],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Center(
                        child: TextField(
                          autofocus: true,
                          controller: _nicknameController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      width: 80.0,
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                        ),
                        controller: _realnameController,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(8.0),
            child: BottomAppBar(
              color: Colors.transparent,
              elevation: 0.0,
              child: CupertinoButton(
                child: Text(
                  '프로필 수정',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                color: eliverdColor,
                borderRadius: BorderRadius.circular(10.0),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                onPressed: () {
                  widget.userBloc.add(UpdateUser(
                    nickname: _nicknameController.text ?? previous.nickname,
                    realname: _realnameController.text ?? previous.realname,
                  ));
                },
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is UserUpdated) {
          widget.userBloc.add(FetchUserInfo(
            month: 0,
          ));
          Navigator.pop(context);
        }
      },
    );
  }
}
