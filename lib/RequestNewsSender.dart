import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yobit_features/GeneralNews.dart';
import 'package:yobit_features/WebViewWebPage.dart';
import 'configs.dart';

class RequestNewsSender extends StatelessWidget {
  RequestNewsSender(this._currentDate, this._q, {Key key}) : super(key: key);

  final _currentDate;
  final _q;
  String _url;

  @override
  Widget build(BuildContext context) {
    _url =
        "https://newsapi.org/v2/everything?q=$_q&from=$_currentDate&sortBy=publishedAt&apiKey=${Configs.apiKey}&language=ru";
    return new Container(
        color: Colors.indigo[500],
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: _url != null
                ? http.get(_url).then((response) => response.body)
                : null,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return new Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (snapshot.hasData) {
                    GeneralNews generalNews =
                        GeneralNews.fromJson(json.decode(snapshot.data));
                    ListView tempList = ListView.builder(
                        itemCount: generalNews.listArticles == null
                            ? 0
                            : generalNews.listArticles.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new ListTile(
                            leading: CircleAvatar(
                                backgroundImage: NetworkImage(generalNews
                                        .listArticles[index].urlToImage ??
                                    "")),
                            title: Text(generalNews.listArticles[index].title,
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                generalNews.listArticles[index].publishedAt,
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return new WebViewWebPage(
                                    url: generalNews.listArticles[index].url);
                              }));
                            },
                          );
                        });
                    //
                    return tempList;
                  }
              } //switch
            }));
  }
}
