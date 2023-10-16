import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';

void showToast(String message) {

  Widget toast = Container(
    width: 408,
    height: 119,
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xff95e1de),
    ),
    child: Center(
      child: TextMessageNormal(message, 16),
    ),
  );

  FToast().showToast(
    child: toast,
    gravity: ToastGravity.CENTER,
    toastDuration: const Duration(seconds: 3),
  );
}