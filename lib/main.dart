import 'package:flutter/material.dart';
import 'NavDrawerInTabbar.dart';
import 'YobitNotifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yobit Demo',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.transparent,
      ),
      home: NavDrawerInTabbar(),

    );
  }
}