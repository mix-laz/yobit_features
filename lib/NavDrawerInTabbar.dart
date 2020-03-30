import 'package:flutter/material.dart';
import 'RequestNewsSender.dart';
import 'configs.dart';
import 'package:date_format/date_format.dart';
import 'PriceNotifications.dart';
import 'package:flutter/cupertino.dart';
import 'ChatNotifications.dart';
import 'BestPrice.dart';

class NavDrawerInTabbar extends StatelessWidget {
  void _openScreen(BuildContext context, DrawerMenu dm) {
    if (dm.widget != null) {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return dm.widget;
          },
          fullscreenDialog: true));
    } else
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<DrawerMenu> _listViewData = <DrawerMenu>[
      DrawerMenu(
          title: "Новости Google ", iconData: CupertinoIcons.info, widget: null),
      DrawerMenu(
          title: "Уведомления цены",
          iconData: CupertinoIcons.mail,
          widget: new PriceNotifications()),
      DrawerMenu(
          title: "Уведомления чата",
          iconData: CupertinoIcons.group,
          widget: new ChatNotifications()),
      DrawerMenu(
          title: "Продажа по парах",
          iconData: CupertinoIcons.shopping_cart,
          widget: new BestPrice())

    ];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: SafeArea(
            child: Drawer(
                child: ClipRRect(
                    borderRadius: new BorderRadius.only(
                        topRight: const Radius.circular(40.0),
                        bottomRight: const Radius.circular(40.0)),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: new BoxDecoration(color: Colors.indigo[700]),
                      child: Column(children: <Widget>[
                        Image(image: AssetImage('assets/89_big.png')),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(5.0),
                            children: _listViewData
                                .map((data) => ListTile(
                                    title: Text(data.title,
                                        style: TextStyle(color: Colors.white)),
                                    leading: Icon(data.iconData,
                                        color: Colors.white),
                                    onTap: () {
                                      _openScreen(context, data);
                                    }))
                                .toList(),
                          ),
                        )
                      ]),
                    )))),
        appBar: AppBar(
          title: Text("Yobit"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Общие",
              ),
              Tab(
                text: "Биткоин",
              ),
              Tab(
                text: "Каннабис",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: RequestNewsSender(
                  formatDate(DateTime.now(), ['yyyy-mm-dd']), "general"),
            ),
            Center(
              child: RequestNewsSender(
                  formatDate(DateTime.now(), ['yyyy-mm-dd']), "bitcoin"),
            ),
            Center(
              child: RequestNewsSender(
                  formatDate(DateTime.now(), ['yyyy-mm-dd']), "marijuana"),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerMenu {
  final String title;
  final IconData iconData;
  final Widget widget;

  DrawerMenu({this.title, this.iconData, this.widget});
}
