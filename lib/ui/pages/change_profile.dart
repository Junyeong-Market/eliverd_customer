import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/bloc/userBloc.dart';
import 'package:Eliverd/bloc/events/userEvent.dart';
import 'package:Eliverd/bloc/states/userState.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/widgets/pick_image.dart';

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

  File _profile;

  User _previous;
  bool _isUserFetched = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<UserBloc, UserState>(
      cubit: widget.userBloc,
      builder: (context, state) {
        if (state is UserFetched && !_isUserFetched) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _previous = state.user;
              _isUserFetched = true;
            });

            _nicknameController.text = _previous.nickname;
            _realnameController.text = _previous.realname;
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
            actions: [
              ButtonTheme(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minWidth: 0,
                height: 0,
                child: FlatButton(
                  padding: EdgeInsets.only(
                    right: 16.0,
                  ),
                  textColor: Colors.black,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    '􀅉',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 24.0,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  onPressed: () {
                    showResetProfileAlertDialog(context);
                  },
                ),
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            children: <Widget>[
              if (state is UserFetched)
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _profile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                                  _profile,
                                  fit: BoxFit.fill,
                                  width: width * 0.5,
                                  height: width * 0.5,
                                ),
                              )
                            : (state.user.profile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.network(
                                      state.user.profile.image,
                                      fit: BoxFit.fill,
                                      width: width * 0.5,
                                      height: width * 0.5,
                                      loadingBuilder: (BuildContext context, Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) return child;

                                        return Container(
                                          width: width * 0.5,
                                          height: width * 0.5,
                                          child: Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    width: width * 0.5,
                                    height: width * 0.5,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black54,
                                            Colors.black26
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _nicknameController.text,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => PickImageDialog(
                                onImageSelected: _onImageSelected,
                              ),
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: eliverdColor,
                              foregroundColor: Colors.white,
                              child: Text(
                                '􀌟',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      width: 120.0,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          isDense: true,
                          hintText: '사용자의 본명',
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w700,
                            fontSize: 22.0,
                          ),
                        ),
                        controller: _realnameController,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 22.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 120.0,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          isDense: true,
                          hintText: '사용자의 닉네임',
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                          ),
                        ),
                        controller: _nicknameController,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
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
                onPressed: isAvailableToChangeProfile ? () {
                  widget.userBloc.add(UpdateUser(
                    nickname: _nicknameController.text ?? _previous.nickname,
                    realname: _realnameController.text ?? _previous.realname,
                    image: _profile ?? null,
                  ));

                  Navigator.pop(context);
                } : null,
              ),
            ),
          ),
        );
      },
    );
  }

  bool get isAvailableToChangeProfile => _nicknameController.text != '' && _realnameController.text != '';

  void _onImageSelected(File image) {
    setState(() {
      _profile = image;
    });
  }

  void _resetProfile() {
    setState(() {
      _nicknameController.text = _previous.nickname;
      _realnameController.text = _previous.realname;

      _profile = null;
    });
  }

  void showResetProfileAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text(
        '취소',
        style: TextStyle(
          color: eliverdColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget confirmButton = FlatButton(
      child: Text(
        '재수정',
        style: TextStyle(
          color: eliverdColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: () {
        _resetProfile();
        Navigator.pop(context);
      },
    );

    Widget cupertinoCancelButton = CupertinoDialogAction(
      child: Text(
        '취소',
        style: TextStyle(
          color: eliverdColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget cupertinoConfirmButton = CupertinoDialogAction(
      child: Text(
        '재수정',
        style: TextStyle(
          color: eliverdColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: () {
        _resetProfile();
        Navigator.pop(context);
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text(
        '프로필을 다시 수정하시겠습니까?',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
      content: Text(
        '재수정 시 이전에 수정한 정보가 모두 초기화됩니다.',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      ),
      actions: <Widget>[
        cancelButton,
        confirmButton,
      ],
    );

    CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
      title: Text(
        '프로필을 다시 수정하시겠습니까?',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
      content: Text(
        '재수정 시 이전에 수정한 정보가 모두 초기화됩니다.',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      ),
      actions: <Widget>[
        cupertinoCancelButton,
        cupertinoConfirmButton,
      ],
    );

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        },
      );
    } else if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return cupertinoAlertDialog;
        },
      );
    }
  }

}
