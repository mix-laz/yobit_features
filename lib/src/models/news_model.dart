class NewsModel {
  List<Article> listArticles;

  NewsModel({this.listArticles});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return new NewsModel(
        listArticles: json['articles'] != null
            ? json['articles']
                .map((value) => new Article.fromJson(value))
                .toList()
                .cast<Article>()
            : null);
  }
}

class Article {
  String author;
  String title;
  String urlToImage;
  String publishedAt;
  String url;

  Article(
      {this.author, this.publishedAt, this.title, this.urlToImage, this.url});

  factory Article.fromJson(Map<String, dynamic> json) {
    return new Article(
        author: json['author'],
        title: json['title'],
        urlToImage: json['urlToImage'],
        publishedAt: json['publishedAt'],
        url: json['url']);
  }
}
