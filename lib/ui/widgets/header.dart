import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Eliverd/common/color.dart';

class Header extends PreferredSize {
  final Function onBackButtonPressed;
  final String title;
  final List<Widget> actions;

  const Header({@required this.onBackButtonPressed, @required this.title, this.actions});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 60.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBar(
            leading: ButtonTheme(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minWidth: 0,
              height: 0,
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                textColor: Colors.white,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  '􀆉',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                  ),
                ),
                onPressed: onBackButtonPressed,
              ),
            ),
            backgroundColor: eliverdColor,
            elevation: 0.0,
            actions: actions,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Text(
              title,
              style: const TextStyle(
                backgroundColor: eliverdColor,
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
        color: eliverdColor,
      ),
    );
  }
}
