
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PriceNotifications extends StatefulWidget {
  @override
  _PriceNotificationsState createState() => _PriceNotificationsState();
}

class _PriceNotificationsState extends State<PriceNotifications> {
  final pairController = TextEditingController();
  final priceController = TextEditingController();
  bool _compare = false;
  List<String> _list;

  @override
  void initState() {
    super.initState();
    pairController.text = "sex_btc";
    priceController.text = "0.00025";
    inicializeListView();
  }

  @override
  void dispose() {
    pairController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void startServiceInPlatform(
      String pair, String price, int cmp, int timestamp) async {
    var methodChannel = MethodChannel("com.yobit_features.messages");
    List<dynamic> dynam = await methodChannel.invokeMethod("startService", {
      "pair": pair,
      "price": price,
      "compare": cmp.toString(),
      "timestamp": timestamp.toString()
    });
    List<String> result = dynam.cast<String>();
    setState(() {
      _list = result;
    });
    debugPrint("");
  }

  void removeUserConditionPriceInPlatform(String timestamp) async {
    debugPrint("timestamp to remove: " + timestamp);

    var methodChannel = MethodChannel("com.yobit_features.messages");
    List<dynamic> dynam = await methodChannel.invokeMethod(
        "removeUserConditionPrice", {"timestamp": timestamp.toString()});
    List<String> result = dynam.cast<String>();
    setState(() {
      _list = result;
    });
  }

  void stopServiceInPlatform() async {
      var methodChannel = MethodChannel("com.yobit_features.messages");
      await methodChannel.invokeMethod('stopService');

  }

  void _changeIcon() {
    setState(() {
      _compare = !_compare;
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
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: _list == null ? 0 : _list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                  child: Center(                         // pair
                                      child: Text(_list.elementAt(index).split(',')[0])),
                              onTap: ()=>{
                                    pairController.text=_list.elementAt(index).split(',')[0],
                                    priceController.text=_list.elementAt(index).split(',')[2],


                              },
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                ((int.parse(_list
                                            .elementAt(index)
                                            .split(',')[1])) ==
                                        1
                                    ? 'assets/right_chevron.png'
                                    : 'assets/left_chevron.png'),
                                height: 30,
                                width: 30,
                              ),
                            ),
                            Expanded(
                                child:                                         // price
                                    Center(child: Text(_list.elementAt(index).split(',')[2]))),
                            Expanded(
                                child: GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(CupertinoIcons.clear_thick),
                                    ),
                                    onTap: () =>
                                        removeUserConditionPriceInPlatform(_list
                                            .elementAt(index)
                                            .split(',')[3])))
                          ]);
                    }),
              ),
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
                        child: GestureDetector(
                      onTap: _changeIcon,
                      child: Image.asset(_compare
                          ? 'assets/right_chevron.png'
                          : 'assets/left_chevron.png',
                        height: 70,
                        width: 70,),
                    )),
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: 'price...'),
                      ),
                    ),
                  ]),
              Row(children: <Widget>[
                Expanded(
                    child: FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          stopServiceInPlatform();
                        },
                        child: Text("Stop Notifications",
                            style: TextStyle(fontSize: 25.0))))
              ]),
              Row(children: <Widget>[
                Expanded(
                    child: FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          startServiceInPlatform(
                              pairController.text,
                              priceController.text,
                              _compare ? 1 : 0,
                              new DateTime.now().millisecondsSinceEpoch);
                        },
                        child: Text("+", style: TextStyle(fontSize: 35.0))))
              ])
            ])));
  }

  void inicializeListView() async {
    var methodChannel = MethodChannel("com.yobit_features.messages");
    List<dynamic> dynam =
        await methodChannel.invokeMethod("getUserConditionsPrice");
    List<String> result = dynam.cast<String>();
    setState(() {
      _list = result;
    });
  }
}
//
