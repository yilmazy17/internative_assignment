import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginRegisterButton extends StatelessWidget {
  LoginRegisterButton(
      {Key? key,
      required this.textValue,
      required this.method,
      this.icon,
      this.background_color,
      this.text_color})
      : super(key: key);
  final background_color;
  final text_color;
  Icon? icon;
  final String textValue;
  final method;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.black, width: 1))),
        backgroundColor:
            MaterialStateProperty.all<Color>(background_color ?? Colors.white),
      ),
      onPressed: method,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon ?? Container(),
          Expanded(
            child: Center(
              child: Text(
                textValue,
                style: TextStyle(
                    color: text_color ?? Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
