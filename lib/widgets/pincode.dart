import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Pincode extends StatelessWidget {
  final int length;
  final TextInputType inputType;
  final Function onPressed;

  Pincode({this.length, this.inputType, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: length,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      autoFocus: true,
      obsecureText: false,
      animationType: AnimationType.fade,
      shape: PinCodeFieldShape.underline,
      animationDuration: Duration(milliseconds: 300),
      borderRadius: BorderRadius.circular(5),
      activeColor: Theme.of(context).primaryColor,
      selectedColor: Colors.blue,
      inactiveColor: Colors.black38,
      backgroundColor: Colors.white.withOpacity(0),
      textInputType: inputType,
      fieldHeight: 50,
      fieldWidth: 40,
      onChanged: (value) {
        onPressed(value);
      },
    );
  }
}
