import 'dart:async';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/news_model.dart';

enum NavBarItem {GENERAL,BITCOIN,CANNABIS}
class NewsBloc {
  final _repository = Repository();
  final _newsFetcher = PublishSubject<NewsModel>();
  final StreamController<NavBarItem> _navBarController=StreamController<NavBarItem>.broadcast();
  Stream<NavBarItem> get navBarStream => _navBarController.stream;
  NavBarItem defaultItem = NavBarItem.GENERAL;

  Stream<NewsModel> get allNews => _newsFetcher.stream;

  String _keyword;
  String get keyword=>_keyword;
  set keyword(String value) {
    _keyword = value;
  }

  fetchAllNews(String date,String keyword) async {
    NewsModel newsModel = await _repository.fetchAllNews(date,keyword);
    _newsFetcher.sink.add(newsModel);
  }
void pickItem(int i){
    switch(i) {
      case 0:
        _navBarController.sink.add(NavBarItem.GENERAL);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.BITCOIN);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.CANNABIS);
        break;
    }
}
  dispose() {
    _newsFetcher.close();
  }
}

final bloc = NewsBloc();