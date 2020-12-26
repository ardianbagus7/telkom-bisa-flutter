import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<Flushbar<bool>> customFlushbar(
  BuildContext context, {
  String msg,
  Color color = const Color(0xFFCF212A),
}) async {
  return Flushbar<bool>(
    duration: Duration(milliseconds: 2000),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: color,
    borderRadius: 10,
    margin: EdgeInsets.only(top: 10, left: 16, right: 16),
    message: msg,
  )..show(context);
}
