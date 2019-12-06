import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class YobitNotifications extends StatefulWidget {
  @override
  _YobitNotificationsState createState() => _YobitNotificationsState();
}

class _YobitNotificationsState extends State<YobitNotifications> {
  final pairController = TextEditingController();
  final priceController = TextEditingController();
  bool _compare=false;

  @override
  void initState() {
    super.initState();
    pairController.text="btc_usd";
    priceController.text="7600";

  }


  @override
  void dispose() {
    pairController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void startServiceInPlatform(String pair,String price,bool cmp,int timestamp) async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.yobit_features.messages");
      String data = await methodChannel.invokeMethod(
          "startService", {"pair": pair, "price": price, "compare":cmp.toString(),"timestamp":timestamp.toString()});
      debugPrint("cmp.toString():"+cmp.toString());
    }
  }

  void _changeIcon(){
    setState(() {
      _compare=!_compare;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            decoration: new BoxDecoration(color: Colors.white),
            height: double.infinity,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //fields
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: pairController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'pair...x_y'),
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(onTap: _changeIcon,
                              child: Image(width: 30,
                                  image: AssetImage(_compare?'assets/right_chevron.png':'assets/left_chevron.png')
                              ),
                            )
                        ),
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'price...'),
                          ),
                        ),
                      ]),
//button
                  Row(children: <Widget>[
                    Expanded(
                        child: FlatButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () {
                              startServiceInPlatform(
                                  pairController.text, priceController.text,_compare,new DateTime.now().millisecondsSinceEpoch);
                            },
                            child: Text("Notify",
                                style: TextStyle(fontSize: 25.0))))
                  ])
                ])));
  }
}
//
