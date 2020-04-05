import 'dart:async';
import 'news_api_provider.dart';
import '../models/news_model.dart';

class Repository {
  final newsApiProvider = NewsApiProvider();

  Future<NewsModel> fetchAllNews (String date,String keyword) => newsApiProvider.fetchNewsList(date, keyword);
}