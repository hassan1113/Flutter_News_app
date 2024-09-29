class News {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;

  News({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      url: json['url'],
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }
}
