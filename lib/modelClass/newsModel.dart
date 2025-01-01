class NewsData {
  String status;
  int totalResults;
  List<Article> articles;

  NewsData({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  // Factory constructor for JSON deserialization
  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      status: json['status'] as String,
      totalResults: json['totalResults'] as int,
      articles: (json['articles'] as List<dynamic>)
          .map((articleJson) => Article.fromJson(articleJson))
          .toList(),
    );
  }
}

class Article {
  Source source;
  String? author;
  String title;
  String? description;
  String url;
  String? urlToImage;
  DateTime publishedAt;
  String content;

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  // Factory constructor for JSON deserialization
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'] as String,
    );
  }
}

class Source {
  String? id;
  String name;

  Source({
    this.id,
    required this.name,
  });

  // Factory constructor for JSON deserialization
  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String?,
      name: json['name'] as String,
    );
  }
}
