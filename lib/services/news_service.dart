import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  static const _baseUrlEverything =
      'https://newsapi.org/v2/everything';

  static const _apiKey = 'ae998e82c3a14062904954b76b8f84ae';

  Future<List<NewsArticle>> getirBusinessNews() async {
    final url = Uri.parse(
      '$_baseUrlEverything'
      '?q=ekonomi'
      '&language=tr'
      '&sortBy=publishedAt'
      '&apiKey=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      print('status: ${data['status']}');
      print('totalResults: ${data['totalResults']}');

      final List<dynamic> articles =
          data['articles'] as List<dynamic>;

      print('articles length: ${articles.length}');

      return articles
          .map(
            (e) => NewsArticle.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    } else {
      print('status: ${response.statusCode}');
      print('body: ${response.body}');
      throw Exception(
        'Did Not Take News. Code: ${response.statusCode}',
      );
    }
  }
}
