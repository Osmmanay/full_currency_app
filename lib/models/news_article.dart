class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      publishedAt:
          DateTime.tryParse(
            json['publishedAt'] as String? ?? '',
          ) ??
          DateTime.now(),
    );
  }
}
