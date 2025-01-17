class NewsSet {
  NewsSet({
    required this.version,
    required this.title,
    required this.homePageUrl,
    required this.feedUrl,
    required this.language,
    required this.description,
    required this.items,
  });

  final String? version;
  final String? title;
  final String? homePageUrl;
  final String? feedUrl;
  final String? language;
  final String? description;
  final List<Item> items;

  factory NewsSet.fromJson(Map<String, dynamic> json){
    return NewsSet(
      version: json["version"],
      title: json["title"],
      homePageUrl: json["home_page_url"],
      feedUrl: json["feed_url"],
      language: json["language"],
      description: json["description"],
      items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );
  }

}

class Item {
  Item({
    required this.id,
    required this.url,
    required this.title,
    required this.contentText,
    required this.contentHtml,
    required this.image,
    required this.datePublished,
    required this.authors,
    required this.attachments,
  });

  final String? id;
  final String? url;
  final String? title;
  final String? contentText;
  final String? contentHtml;
  final String? image;
  final DateTime? datePublished;
  final List<Author> authors;
  final List<Attachment> attachments;

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      id: json["id"],
      url: json["url"],
      title: json["title"],
      contentText: json["content_text"],
      contentHtml: json["content_html"],
      image: json["image"],
      datePublished: DateTime.tryParse(json["date_published"] ?? ""),
      authors: json["authors"] == null ? [] : List<Author>.from(json["authors"]!.map((x) => Author.fromJson(x))),
      attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
    );
  }

}

class Attachment {
  Attachment({
    required this.url,
  });

  final String? url;

  factory Attachment.fromJson(Map<String, dynamic> json){
    return Attachment(
      url: json["url"],
    );
  }

}

class Author {
  Author({
    required this.name,
  });

  final String? name;

  factory Author.fromJson(Map<String, dynamic> json){
    return Author(
      name: json["name"],
    );
  }

}
