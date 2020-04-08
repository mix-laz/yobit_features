import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:yobit_features/src/models/news_model.dart';
import 'package:yobit_features/src/resources/configs.dart';
import 'package:date_format/date_format.dart';


class NewsApiProvider {
  Client client = Client();
  //final _currentDate=formatDate(DateTime.now(), ['yyyy-mm-dd']);


  Future<NewsModel> fetchNewsList(String date,String keyword) async {
    print("entered");
    final response = await client
        .get("https://newsapi.org/v2/everything?q=$keyword&from=$date&sortBy=publishedAt&apiKey=${Configs.apiKey}&language=ru");
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load news');
    }
  }

}

