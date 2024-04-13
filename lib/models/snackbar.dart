import 'package:flutter/material.dart';

void showSnackbarOnScreen(BuildContext context, String s) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
}
