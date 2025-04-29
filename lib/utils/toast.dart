import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String title, bool isSuccess) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: title,
    backgroundColor: isSuccess ? Colors.black : Colors.red,
    textColor: Colors.white,
  );
}
