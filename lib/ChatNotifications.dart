
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ChatNotifications extends StatefulWidget {
  @override
  _ChatNotificationsState createState() => _ChatNotificationsState();
}

class _ChatNotificationsState extends State<ChatNotifications> {
  final nickController = TextEditingController();
  List<String> _list;

  @override
  void initState() {
    super.initState();
    pairController.text = "mikro_btc";
    priceController.text = "0.000179";
  }


  @override
  void dispose() {
    nickController.dispose();
    super.dispose();
  }

  void trackingNickInPlatform(
      String nick) async {
    var methodChannel = MethodChannel("com.yobit_features.messages");
    List<dynamic> dynam = await methodChannel.invokeMethod("trackingNick", {
      "nick": nick
    });
    List<String> result = dynam.cast<String>();
    setState(() {
      _list = result;
    });
    debugPrint("result: "+result.toString());
  }

  void removeNickInPlatform(String name) async {
    var methodChannel = MethodChannel("com.yobit_features.messages");
    List<dynamic> dynam = await methodChannel.invokeMethod(
        "removeNick", {"name":name});
    List<String> result = dynam.cast<String>();
    setState(() {
      _list = result;
    });
  }

  void stopServiceInPlatform() async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.yobit_features.messages");
      await methodChannel.invokeMethod('stopService');
    }
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
                              child: Center(child: Text(_list.elementAt(index))),
                            ),

                            Expanded(
                                child: GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(CupertinoIcons.clear_thick),
                                    ),
                                    onTap: () =>
                                        removeNickInPlatform(_list.elementAt(index)))
                            )
                          ]);
                    }),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: nickController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'nick...'),
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
                          trackingNickInPlatform(      nickController.text);

                        },
                        child: Text("+", style: TextStyle(fontSize: 35.0))))
              ])
            ])));
  }

  void inicializeListView() async {
    var methodChannel = MethodChannel("com.yobit_features.messages");
    List<dynamic> dynam =    await methodChannel.invokeMethod("getNickList");
    List<String> result = dynam.cast<String>();
    setState(() {
      _list = result;
    });
  }
}
//
