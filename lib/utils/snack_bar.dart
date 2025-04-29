import 'package:flutter/material.dart';
import 'package:realtime_chat/my_app.dart';

showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
