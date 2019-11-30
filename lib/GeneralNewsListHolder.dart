
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'GeneralNews.dart';



class GeneralNewsListHolder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GeneralNewsState();
  }
}

class GeneralNewsState extends State<GeneralNewsListHolder>{
	String _url;
 

var log;
List newsList; 
//final String url = "https://newsapi.org/v2/everything?q=bitcoin&from=2019-08-29&sortBy=publishedAt&apiKey="+Configs.apiKey;
Future<GeneralNews> post;

@override
Widget build(BuildContext context){
	
 
return new Scaffold(   
  appBar: AppBar(
      title: Text('$log'),
    ),
    body: null
     /* FutureBuilder<GeneralNews>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.listArticles);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            }
) */

);
	}
	
@override
void initState() {
    super.initState();	  
    //post = fetchPost();
}
/* 
Future<GeneralNews> fetchPost() async {
  final response =
      await http.get(url);

  if (response.statusCode == 200) {    
    return GeneralNews.fromJson(json.decode(response.body));
  } else {    
    throw Exception('Failed to load post');
  }
} */

/* void loadData() async {
    String rawData = (await http.get(endpoint)).body;
	Map jsonData = json.decode(rawData);
 
	setState(() {
		newsList = GeneralNews.fromJson(jsonData);	
});
} */
}