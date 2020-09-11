import 'package:Eliverd/common/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/bloc/userBloc.dart';
import 'package:Eliverd/bloc/events/userEvent.dart';
import 'package:Eliverd/bloc/states/userState.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  final UserBloc userBloc;

  const UserProfile({Key key, @required this.userBloc}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<int, int> maximumMonth = {
    0: 3,
    1: 6,
    2: 0,
  };
  int _selectedTab = 2;

  @override
  void initState() {
    super.initState();

    widget.userBloc.add(FetchUserInfo(
      month: maximumMonth[_selectedTab],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<UserBloc, UserState>(
      cubit: widget.userBloc,
      builder: (context, state) {
        if (state is UserInfoFetched) {
          return Column(
            children: <Widget>[
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
                  child: Text(
                    state.user.nickname,
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
              Text(
                state.user.realname,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 19.0,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '주문 아카이브',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Expanded(
                    child: CupertinoSegmentedControl(
                      unselectedColor: Colors.white,
                      pressedColor: eliverdDarkColor,
                      selectedColor: eliverdDarkColor,
                      borderColor: eliverdDarkColor,
                      children: const <int, Widget>{
                        0: Text(
                          '최근 3개월',
                        ),
                        1: Text(
                          '최근 6개월',
                        ),
                        2: Text(
                          '최근 1년',
                        ),
                      },
                      groupValue: this._selectedTab,
                      onValueChanged: (value) {
                        setState(() {
                          _selectedTab = value;
                        });

                        widget.userBloc.add(FetchUserInfo(
                          month: maximumMonth[_selectedTab],
                        ));
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  right: 16.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '최근 주문 횟수',
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            NumberFormat.compact(
                              locale: 'ko',
                            )?.format(state.count).toString(),
                            maxLines: 2,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '사용 총액',
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            NumberFormat.compact(
                              locale: 'ko',
                            )?.format(state.total).toString(),
                            maxLines: 2,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    textColor: Colors.black12,
                    child: Text(
                      '⟳',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 48.0,
                      ),
                    ),
                    onPressed: () {
                      widget.userBloc.add(FetchUserInfo(
                        month: maximumMonth[_selectedTab],
                      ));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
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
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}
