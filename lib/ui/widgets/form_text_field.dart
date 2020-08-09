import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextField extends StatefulWidget {
  final regex;
  final maxLength;
  final isObscured;
  final controller;
  final helperText;
  final errorMessage;
  final isFocused;
  final onSubmitted;
  final focusNode;
  final prefixText;
  final isEnabled;

  const FormTextField({
    Key key,
    @required this.controller,
    this.errorMessage,
    this.helperText,
    this.regex,
    this.isObscured,
    this.maxLength,
    this.isFocused,
    this.onSubmitted,
    this.focusNode,
    this.prefixText,
    this.isEnabled,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.done,
      inputFormatters: widget.regex == null
          ? [
              FilteringTextInputFormatter(
                RegExp(''),
                allow: false,
              )
            ]
          : widget.regex is List ? widget.regex : [widget.regex],
      maxLength: widget.maxLength,
      maxLengthEnforced: widget.maxLength == null ? false : true,
      obscureText: widget.isObscured ?? false,
      controller: widget.controller ?? null,
      autocorrect: false,
      keyboardAppearance: Brightness.light,
      focusNode: widget.focusNode ?? null,
      autofocus: widget.isFocused ?? false,
      enabled: widget.isEnabled ?? true,
      decoration: InputDecoration(
        helperText: widget.helperText ?? '',
        contentPadding: EdgeInsets.all(2.0),
        isDense: true,
        errorText: widget.errorMessage ?? null,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        prefixText: widget.prefixText ?? null,
      ),
      style: TextStyle(
        fontSize: 22.0,
        color: Colors.black54,
      ),
      onSubmitted: widget.onSubmitted ?? null,
    );
  }
}
