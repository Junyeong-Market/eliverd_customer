import 'dart:async';

import 'package:Eliverd/ui/pages/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Eliverd/bloc/authBloc.dart';
import 'package:Eliverd/bloc/events/authEvent.dart';
import 'package:Eliverd/bloc/states/authState.dart';

import 'package:Eliverd/common/color.dart';
import 'package:Eliverd/common/string.dart';
import 'package:Eliverd/common/key.dart';

import 'package:Eliverd/ui/pages/home.dart';
import 'package:Eliverd/ui/pages/sign_up.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  bool errorOccurred = false;
  bool isLoggedInOnce = false;
  String errorMessage = '';

  Timer timer;

  @override
  void initState() {
    super.initState();

    _prefs.then((prefs) {
      _idController.text = prefs.getString('userId') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';

      context.bloc<AuthenticationBloc>().add(CheckAuthentication());
    });

    timer = Timer.periodic(
      Duration(
        minutes: 10,
      ),
      (Timer t) {
        context.bloc<AuthenticationBloc>().add(CheckAuthentication());
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          _setErrorActivate(state);
        } else {
          _setErrorDeactivate(state);
        }

        if (state is Authenticated) {
          setState(() {
            isLoggedInOnce = true;
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }

        if (state is NotAuthenticated && isLoggedInOnce) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreenPage(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            key: LoginPageKeys.loginPage,
            appBar: _transparentAppBar,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    SignInStrings.alreadyLoggedIn,
                    style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  CupertinoActivityIndicator(),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          key: LoginPageKeys.loginPage,
          appBar: _transparentAppBar,
          body: ListView(
            padding: EdgeInsets.only(
              left: width * 0.15,
              right: width * 0.15,
              top: height * 0.15,
              bottom: height * 0.15,
            ),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildLoginPageLogo(width),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildLoginErrorSection(height),
                      _buildIdFieldSection(),
                      SizedBox(height: height / 88.0),
                      _buildPasswordFieldSection(),
                      SizedBox(height: height / 88.0),
                      _buildSignInSection(),
                      _buildSignUpSection(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  final _idRegex = FilteringTextInputFormatter(
    RegExp("[a-zA-Z0-9^\s]"),
    allow: true,
  );
  final _passwordRegex = FilteringTextInputFormatter(
    RegExp("[a-zA-Z0-9\x01-\x19\x21-\x7F]"),
    allow: true,
  );

  final _passwordNavigationFocus = FocusNode();

  final _transparentAppBar = AppBar(
    backgroundColor: Colors.transparent,
    brightness: Brightness.light,
    elevation: 0.0,
    automaticallyImplyLeading: false,
  );

  Widget _buildLoginPageLogo(double width) => Image(
        key: LoginPageKeys.loginLogo,
        width: width / 1.5,
        height: width / 1.5,
        image: AssetImage('assets/images/logo/eliverd_logo_original.png'),
      );

  Widget _buildLoginErrorSection(double height) => Visibility(
        key: LoginPageKeys.loginErrorMsg,
        child: Column(
          children: <Widget>[
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height / 120.0),
          ],
        ),
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: errorOccurred,
      );

  Widget _buildIdFieldSection() => TextField(
        key: LoginPageKeys.idTextField,
        obscureText: false,
        autocorrect: false,
        inputFormatters: [_idRegex],
        keyboardAppearance: Brightness.light,
        controller: _idController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          labelText: SignInStrings.idText,
        ),
        onSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordNavigationFocus);
        },
      );

  Widget _buildPasswordFieldSection() => TextField(
        focusNode: _passwordNavigationFocus,
        key: LoginPageKeys.passwordTextField,
        autocorrect: false,
        obscureText: true,
        keyboardAppearance: Brightness.light,
        inputFormatters: [_passwordRegex],
        controller: _passwordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          labelText: SignInStrings.passwordText,
        ),
      );

  Widget _buildSignInSection() => ButtonTheme(
        minWidth: double.infinity,
        child: CupertinoButton(
          key: LoginPageKeys.loginBtn,
          child: Text(
            SignInStrings.login,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          color: eliverdColor,
          borderRadius: BorderRadius.circular(15.0),
          padding: EdgeInsets.symmetric(
            vertical: 15.0,
          ),
          onPressed: () {
            context.bloc<AuthenticationBloc>().add(GrantAuthentication(
                _idController.text, _passwordController.text));
          },
        ),
      );

  Widget _buildSignUpSection() => FlatButton(
        key: LoginPageKeys.signUpBtn,
        child: Text(
          SignInStrings.notSignUp,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(),
            ),
          );
        },
      );

  void _setErrorActivate(AuthenticationState state) {
    if (state is! AuthenticationError) {
      throw Exception('Tried to activate error when error is not occurred!');
    }

    setState(() {
      errorOccurred = true;
      errorMessage = (state as AuthenticationError).errorMessage;
    });
  }

  void _setErrorDeactivate(AuthenticationState state) {
    if (state is AuthenticationError) {
      throw Exception(
          'Tried to deactivate error when error is not completely solved!');
    }
    setState(() {
      errorOccurred = false;
      errorMessage = '';
    });
  }
}
