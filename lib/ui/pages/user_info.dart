import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/bloc/userBloc.dart';
import 'package:Eliverd/bloc/states/userState.dart';

class UserPage extends StatefulWidget {
  final UserBloc userBloc;
  final User user;

  const UserPage({Key key, @required this.userBloc, @required this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      cubit: widget.userBloc,
      builder: (context, state) {
      },
    );
  }
}
