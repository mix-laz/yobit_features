import 'package:flutter/material.dart';
import 'package:yobit_features/src/models/news_model.dart';
import '../resources/configs.dart';
import 'package:date_format/date_format.dart';
import '../../PriceNotifications.dart';
import 'package:flutter/cupertino.dart';
import '../../ChatNotifications.dart';
import '../../BestPrice.dart';
import '../blocs/NewsBloc.dart';
import 'package:yobit_features/WebViewWebPage.dart';

class NavDrawerInTabbar extends StatelessWidget {
  TabController _tabController;

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
    //_tabController = TabController(vsync: this, length: myTabs.length);
    List<DrawerMenu> _listViewData = <DrawerMenu>[
      DrawerMenu(
          title: "Новости Google ",
          iconData: CupertinoIcons.info,
          widget: null),
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
            onTap: bloc.pickItem,
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
        body: StreamBuilder<NavBarItem>(
            stream: bloc.navBarStream,
            initialData: bloc.defaultItem,
            builder:
                (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
              switch (snapshot.data) {
                case NavBarItem.GENERAL:
                  bloc.keyword = 'general';
                  break;
                case NavBarItem.BITCOIN:
                  bloc.keyword = 'bitcoin';
                  break;
                case NavBarItem.CANNABIS:
                  bloc.keyword = 'marijuana';
                  break;
              }
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: buildList(formatDate(DateTime.now(), ['yyyy-mm-dd']),
                        bloc.keyword),
                  ),
                  Center(
                    child: buildList(formatDate(DateTime.now(), ['yyyy-mm-dd']),
                        bloc.keyword),
                  ),
                  Center(
                    child: buildList(formatDate(DateTime.now(), ['yyyy-mm-dd']),
                        bloc.keyword),
                  )
                ],
              );
            }),
      ),
    );
  }

  Widget buildList(String date, String keyword) {
    bloc.fetchAllNews(date, keyword);
    return Container(
      color: Colors.indigo[500],
      child: StreamBuilder<NewsModel>(
          stream: bloc.allNews,
          builder: (BuildContext context, AsyncSnapshot<NewsModel> snapshot) {
            if ((snapshot == null) || (snapshot.data == null))
              return ListView();
            ListView tempList = ListView.builder(
                itemCount: snapshot.data.listArticles == null
                    ? 0
                    : snapshot.data.listArticles.length,
                itemBuilder: (BuildContext context, int index) {
                  return new ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data.listArticles[index].urlToImage ??
                                "")),
                    title: Text(snapshot.data.listArticles[index].title,
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                        snapshot.data.listArticles[index].publishedAt,
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new WebViewWebPage(
                            url: snapshot.data.listArticles[index].url);
                      }));
                    },
                  );
                });
            return tempList;
          }),
    );
  }
}

class DrawerMenu {
  final String title;
  final IconData iconData;
  final Widget widget;

  DrawerMenu({this.title, this.iconData, this.widget});
}
