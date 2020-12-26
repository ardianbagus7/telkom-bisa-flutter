import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:telkom_bisa/widget/flushbar.dart';

part 'constant.dart';
part 'widget/cached_image_custom.dart';
part 'widget/navbar_drawer.dart';
part 'pages/homepage.dart';
part 'pages/detail_page.dart';
part 'pages/login_page.dart';
part 'pages/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}


