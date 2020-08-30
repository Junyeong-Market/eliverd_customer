import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/resources/repositories/repositories.dart';

import 'package:Eliverd/bloc/accountBloc.dart';
import 'package:Eliverd/bloc/events/accountEvent.dart';
import 'package:Eliverd/bloc/states/accountState.dart';

import 'package:Eliverd/common/key.dart';
import 'package:Eliverd/common/string.dart';
import 'package:Eliverd/common/color.dart';

import 'package:Eliverd/ui/widgets/form_text_field.dart';
import 'package:Eliverd/ui/widgets/form_text.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSeller = false;

  final _realnameNavigationFocus = FocusNode();
  final _nicknameNavigationFocus = FocusNode();
  final _userIdNavigationFocus = FocusNode();
  final _passwordNavigationFocus = FocusNode();

  bool _isRealnameSubmitted = false;
  bool _isNicknameSubmitted = false;
  bool _isUserIdSubmitted = false;
  bool _isPasswordSubmitted = false;

  AccountBloc _accountBloc;

  @override
  void initState() {
    super.initState();

    _accountBloc = AccountBloc(
      accountRepository: AccountRepository(
        accountAPIClient: AccountAPIClient(
          httpClient: http.Client(),
        ),
      ),
    );

    _realnameNavigationFocus.requestFocus();
  }

  @override
  void dispose() {
    _accountBloc.close();

    _realnameNavigationFocus.dispose();
    _nicknameNavigationFocus.dispose();
    _userIdNavigationFocus.dispose();
    _passwordNavigationFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider<AccountBloc>.value(
      value: _accountBloc,
      child: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountDoneCreate) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: SignUpPageKeys.signUpPage,
            appBar: _buildAppBar(context),
            body: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              children: <Widget>[
                _buildTitle(),
                SizedBox(
                  height: 16.0,
                ),
                _buildRealnameSection(state, height),
                _buildNicknameSection(state, height),
                _buildUserIdSection(state, height),
                _buildPasswordSection(state, height),
                _buildIsSellerSection(state, height),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: _buildSignUpBtn(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) => AppBar(
    backgroundColor: Colors.transparent,
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
    elevation: 0.0,
    iconTheme: IconThemeData(color: Colors.black),
  );

  final _nameRegex = FilteringTextInputFormatter(
    RegExp("[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣^\s]"),
    allow: true,
  );
  final _nicknameRegex = FilteringTextInputFormatter(
    RegExp("[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣^\s]"),
    allow: true,
  );
  final _idRegex = FilteringTextInputFormatter(
    RegExp("[a-zA-Z0-9^\s]"),
    allow: true,
  );
  final _passwordRegex = FilteringTextInputFormatter(
    RegExp("[a-zA-Z0-9\x01-\x19\x21-\x7F]"),
    allow: true,
  );

  Widget _buildTitle() => Text(
    TitleStrings.signUpTitle,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 36.0,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _buildRealnameSection(AccountState state, double height) => Visibility(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormText(
          controller: _nameController,
          textWhenCompleted: SignUpStrings.realnameDesc,
          textWhenNotCompleted: SignUpStrings.realnameDescWhenImcompleted,
        ),
        SizedBox(
          height: 8.0,
        ),
        FormTextField(
          key: SignUpPageKeys.realnameTextField,
          regex: _nameRegex,
          maxLength: 128,
          isObscured: false,
          controller: _nameController,
          isEnabled: !_isRealnameSubmitted,
          helperText: SignUpStrings.realnameHelperText,
          errorMessage: getErrorMessage(
              state, 'realname', ErrorMessages.realnameInvalidMessage),
          focusNode: _realnameNavigationFocus,
          onSubmitted: (_) {
            if (_nameController.text.length != 0) {
              setState(() {
                _isRealnameSubmitted = true;
              });

              _nicknameNavigationFocus.requestFocus();
            }

            // TO-DO: 이름 미입력 시 Snackbar 띄우기
          },
        ),
      ],
    ),
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: true,
  );

  Widget _buildNicknameSection(AccountState state, double height) => Visibility(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormText(
          controller: _nicknameController,
          textWhenCompleted: SignUpStrings.nicknameDesc,
          textWhenNotCompleted: SignUpStrings.nicknameDescWhenImcompleted,
        ),
        SizedBox(
          height: 8.0,
        ),
        FormTextField(
          key: SignUpPageKeys.nicknameTextField,
          regex: _nicknameRegex,
          maxLength: 50,
          isObscured: false,
          controller: _nicknameController,
          helperText: SignUpStrings.nicknameHelperText,
          isEnabled: !_isNicknameSubmitted,
          errorMessage: getErrorMessage(
              state,
              'nickname',
              ErrorMessages.nicknameInvalidMessage,
              ErrorMessages.nicknameDuplicatedMessage),
          focusNode: _nicknameNavigationFocus,
          onSubmitted: (_) {
            if (_nicknameController.text.length != 0) {
              setState(() {
                _isNicknameSubmitted = true;
              });

              _userIdNavigationFocus.requestFocus();
            } else {
              _nicknameNavigationFocus.requestFocus();
            }

            // TO-DO: 닉네임 미입력 시 Snackbar 띄우기
          },
        ),
      ],
    ),
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: _isRealnameSubmitted,
  );

  Widget _buildUserIdSection(AccountState state, double height) => Visibility(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormText(
          controller: _userIdController,
          textWhenCompleted: SignUpStrings.idDesc,
          textWhenNotCompleted: SignUpStrings.idDescWhenImcompleted,
        ),
        SizedBox(
          height: 8.0,
        ),
        FormTextField(
          key: SignUpPageKeys.idTextField,
          regex: _idRegex,
          maxLength: 50,
          isObscured: false,
          controller: _userIdController,
          helperText: SignUpStrings.userIdHelperText,
          isEnabled: !_isUserIdSubmitted,
          errorMessage: getErrorMessage(
              state,
              'userId',
              ErrorMessages.userIdInvalidMessage,
              ErrorMessages.userIdDuplicatedMessage),
          focusNode: _userIdNavigationFocus,
          onSubmitted: (_) {
            if (_userIdController.text.length != 0) {
              setState(() {
                _isUserIdSubmitted = true;
              });

              _passwordNavigationFocus.requestFocus();
            } else {
              _userIdNavigationFocus.requestFocus();
            }
          },
        ),
      ],
    ),
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: _isNicknameSubmitted,
  );

  Widget _buildPasswordSection(AccountState state, double height) => Visibility(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormText(
          controller: _passwordController,
          textWhenCompleted: SignUpStrings.passwordDesc,
          textWhenNotCompleted: SignUpStrings.passwordDescWhenImcompleted,
        ),
        SizedBox(
          height: 8.0,
        ),
        FormTextField(
          key: SignUpPageKeys.passwordTextField,
          maxLength: 256,
          isObscured: true,
          helperText: SignUpStrings.passwordHelperText,
          controller: _passwordController,
          isEnabled: !_isPasswordSubmitted,
          regex: _passwordRegex,
          errorMessage: getErrorMessage(
              state, 'password', ErrorMessages.passwordInvalidMessage),
          focusNode: _passwordNavigationFocus,
          onSubmitted: (value) {
            if (_passwordController.text.length != 0) {
              setState(() {
                _isPasswordSubmitted = true;
              });

              _passwordNavigationFocus.unfocus();
            } else {
              _passwordNavigationFocus.requestFocus();
            }
          },
        ),
      ],
    ),
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: _isUserIdSubmitted,
  );

  Widget _buildIsSellerSection(AccountState state, double height) => Visibility(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              SignUpStrings.isSellerDesc,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 26.0,
              ),
            ),
            CupertinoSwitch(
              key: SignUpPageKeys.isSellerSwitch,
              value: _isSeller,
              onChanged: (value) {
                setState(() {
                  _isSeller = value;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Visibility(
          key: SignUpPageKeys.signUpErrorMsg,
          child: Text(
            ErrorMessages.signUpErrorMessage,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          maintainSize: false,
          maintainAnimation: true,
          maintainState: true,
          visible: state is AccountError,
        ),
      ],
    ),
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: _isPasswordSubmitted,
  );

  Widget _buildSignUpBtn() => BottomAppBar(
    color: Colors.transparent,
    elevation: 0.0,
    child: CupertinoButton(
      key: SignUpPageKeys.signUpBtn,
      child: Text(
        SignUpStrings.signUpButtonDesc,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 19.0,
        ),
      ),
      color: eliverdColor,
      borderRadius: BorderRadius.circular(10.0),
      padding: EdgeInsets.symmetric(vertical: 16.0),
      onPressed: _passwordController.text.length != 0
          ? validateAndSignUpUser
          : null,
    ),
  );

  String getErrorMessage(
      AccountState state, String fieldName, String invalidMsg,
      [String duplicateMsg]) {
    if (isInvalidField(state, fieldName)) {
      return invalidMsg;
    } else if (duplicateMsg != null && isDuplicatedField(state, fieldName)) {
      return duplicateMsg;
    } else {
      return null;
    }
  }

  void validateAndSignUpUser() {
    Map<String, dynamic> jsonifiedUser = {
      'realname': _nameController.text,
      'nickname': _nicknameController.text,
      'user_id': _userIdController.text,
      'password': _passwordController.text,
      'is_seller': _isSeller.toString(),
    };

    _accountBloc.add(ValidateAccount(jsonifiedUser));
    _accountBloc.add(CreateAccount(jsonifiedUser));
  }

  bool isInvalidField(AccountState state, String fieldName) {
    return state is AccountValidateFailed &&
        (state.jsonifiedValidation[fieldName] as String).contains('exists');
  }

  bool isDuplicatedField(AccountState state, String fieldName) {
    return state is AccountValidateFailed &&
        (state.jsonifiedValidation[fieldName] as String).contains('Ensure');
  }
}
