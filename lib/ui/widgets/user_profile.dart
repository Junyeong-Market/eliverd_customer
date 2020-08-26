import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:Eliverd/bloc/userBloc.dart';
import 'package:Eliverd/bloc/events/userEvent.dart';
import 'package:Eliverd/bloc/states/userState.dart';

import 'package:Eliverd/resources/providers/accountProvider.dart';
import 'package:Eliverd/resources/repositories/accountRepository.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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

    _userBloc.add(FetchUser());
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<UserBloc, UserState>(
      cubit: _userBloc,
      builder: (context, state) {
        if (state is UserFetched) {
          return InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: null));
            },
            child: Row(
              children: <Widget>[
                Container(
                  width: width * 0.25,
                  height: width * 0.25,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black54, Colors.black26],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child: Text(
                      state.user.nickname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user.realname,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      state.user.isSeller ? '사업자' : '고객',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(
            child: Column(
              children: [
                ButtonTheme(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minWidth: 0,
                  height: 0,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    textColor: Colors.black12,
                    child: Text(
                      '⟳',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 56.0,
                      ),
                    ),
                    onPressed: () {
                      _userBloc.add(FetchUser());
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  '유저 프로필을 불러오는 중 오류가 발생했습니다.\n다시 시도해주세요.',
                  style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '유저 프로필을 불러오고 있습니다.\n잠시만 기다려주세요.',
                style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.0),
              CupertinoActivityIndicator(),
            ],
          ),
        );
      },
    );
  }
}
